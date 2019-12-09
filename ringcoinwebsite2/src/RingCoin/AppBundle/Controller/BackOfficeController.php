<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 31/10/17
 * Time: 10:22
 */

namespace RingCoin\AppBundle\Controller;


use FOS\UserBundle\Model\UserManagerInterface;
use JMS\Serializer\SerializerBuilder;
use RingCoin\AppBundle\Entity\Transactions;
use RingCoin\AppBundle\Entity\User;
use RingCoin\AppBundle\Events\NotifyEvent;
use RingCoin\AppBundle\Events\RingCoinEvents;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

use Nelmio\ApiDocBundle\Annotation as Doc;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Yaml\Dumper;

/**
 * Class AdminController
 * @package RingCoin\AppBundle\Controller
 * @Route("/backoffice")
 */
class BackOfficeController extends Controller
{

    /**
     * action permettant au user d'acheter des pieces ringCoin
     * @Route("/deposit/{x}", name="backoffice_deposit")
     * @Method({"POST", "GET"})
     */
    public function buyRingCoinAction(Request $request, $x)
    {

       if (!$request->isXmlHttpRequest()){
            throw new AccessDeniedHttpException('Impossible d\'acceder depuis le naviguateur');
        }

        if (!$this->get('security.authorization_checker')->isGranted('ROLE_USER')) {
            return new Response('non user', Response::HTTP_BAD_REQUEST);
        }

        $client = $this->get('ring_coin_app.authentication')->authenticateCoinBaseApi($this->getParameter('cle_api_coinbase'), $this->getParameter('cle_secrete_coinbase'));
        $em = $this->getDoctrine()->getManager();
        $user = $em->getRepository(User::class)->find($this->getUser()->getId());
        $session = $request->getSession();
        $toast='';
        $data=[];
        $response=''; $resp = new Response('empty');

        $prixRC=0;
        $address='';
        $totalPiecesVendues=0;
        $start = new \DateTime();
        $end = new \DateTime();

        $currentDate =  new \DateTime('now', new \DateTimeZone('Africa/Douala'));
        $serializer = SerializerBuilder::create()->build();

        $dateFirst = date('d/m/Y', strtotime('2017/12/04 +28 day'));
        $dateSecond = date('d/m/Y', strtotime(strval($dateFirst).'+22 day'));
        $dateThird = date('d/m/Y', strtotime(strval($dateSecond).'+10 day'));

        if ($currentDate<=$dateFirst){
            $start = $currentDate;
            $end = $dateFirst;
        }else if ($currentDate>$dateFirst && $currentDate<=$dateSecond){
            $start = $currentDate;
            $end = $dateSecond;
        }else if ($currentDate>$dateSecond && $currentDate<=$dateThird){
            $start = $currentDate;
            $end = $dateThird;
        }

        $repTransactions = $em->getRepository(Transactions::class);
        $transactions = $repTransactions->createQueryBuilder('t')
                        ->where('t.statu = :statu')
                        ->andWhere('t.date BETWEEN :start AND :end')
                        ->setParameters(array('start'=>$start, 'end'=>$end, 'statu'=>'completed'))
                        ->getQuery()
                        ->getResult();

        foreach ($transactions as $transaction){
            $totalPiecesVendues += $transaction->getNbrePieces();
        }

        if ($currentDate<=$dateFirst || $totalPiecesVendues<=20000000){
            $prixRC = 0.085;
        }else if ( ($currentDate>$dateFirst && $currentDate<=$dateSecond) || $totalPiecesVendues<=25000000){
            $prixRC = 0.4;
        }else if (($currentDate>$dateSecond && $currentDate<=$dateThird) || $totalPiecesVendues<=6756000){
            $prixRC = 0.7;
        }

        $data['prixRC']=$prixRC;
        $data['totalPiecesVendues']=$totalPiecesVendues;
        $data['fileParameter']=$this->getParameter('kernel.project_dir').'/app/config/app_parameters.yml';

        $this->get('ring_coin_app.authentication')->writeParameter($data);

        $typePaiement = $x;
        //$mtn = $request->request->get('mtn');

        if ($typePaiement==null){
            throw new BadRequestHttpException('Les donnees sont invalides');
        }

        if($typePaiement=='BTC'){
            $address = $user->getAdrBTC();
        }elseif ($typePaiement='ETH'){
            $address = $user->getAdrETH();
        }else{
            $address = $user->getAdrLTC();
        }

        $coinBaseTransactions = $this->get('ring_coin_app.authentication')->getCoinBaseTransactionsUser($typePaiement, $address);

       if($coinBaseTransactions!=null && $coinBaseTransactions[0]['network']['hash']!=null){

            $transactionExist = $em->getRepository(Transactions::class)
                ->findOneByMotif($coinBaseTransactions[0]['network']['hash']);

            if ($transactionExist==null){

                $transaction = new Transactions();
                $transaction->setUser($user);
                $transaction->setType('achat');
                $transaction->setStatu($coinBaseTransactions[0]['status']);
                $transaction->setAdrTransaction($address);
                $transaction->setTypeAdr($typePaiement);
                $transaction->setNbrePieces($coinBaseTransactions[0]['native_amount']['amount']/$prixRC);
                $transaction->setMotif($coinBaseTransactions[0]['network']['hash']);
                $user->addTransaction($transaction);

                $em->persist($transaction);

                if ($coinBaseTransactions[0]['status']=='completed'){

                    if ($user->getParrain()){
                        $transactionParrain = new Transactions();
                        $transactionParrain->setStatu('completed');
                        $transactionParrain->setMotif('backoffice.motifparrainage');
                        $transactionParrain->setNbrePieces(($transaction->getNbrePieces()*5)/100);
                        $transactionParrain->setUser($user->getParrain());
                        $transactionParrain->setType('bonus');
                        $user->getParrain()->setPiecesBonus(($transaction->getNbrePieces()*5)/100);
                        $user->getParrain()->addTransaction($transactionParrain);
                        $em->persist($user->getParrain());
                        $em->persist($transactionParrain);

                    }

                    $user->setPiecesAchete($transaction->getNbrePieces());


                }else{
                    $response = $this->checkPayment();
                }

                $em->persist($user);
                $em->flush();

            }elseif ($transactionExist!=null && $transactionExist->getStatu()=='pending'){
                $response = $this->checkPayment();
            }

            if ($response=='pending'){
                $resp = new Response($response, Response::HTTP_CREATED);
            }elseif ($response=='completed'){
                $resp = new Response($response, Response::HTTP_ACCEPTED);
            }

        }


        $request->getSession()
            ->getFlashBag()
            ->add('toast_success', 'backoffice.msgFlash.transactionPending');

     /* $response = new Response();
      $response->setContent($coinBaseTransactions);*/

        return $resp;

    }


    /**
     * @return Response
     * @Route("/buyMobileMoney", name="buy_mobile_money")
     * @Security("has_role('ROLE_USER')")
     * @Method({"POST"})
     */
    public function buyMobileMoney(Request $request){
        $tel = $request->request->get('numTel');
        $mtn = $request->request->get('mtn');
        $typePaiement = $request->request->get('typePaiement');
        $idTransaction = $request->request->get('idTransaction');

        /** @var $dispatcher EventDispatcherInterface */
        $dispatcher = $this->get('event_dispatcher');
        $parameters = [];
        $parameters['fromEmail']=$parameters['toEmail']='payment@ringcorp.org';
        $parameters['subject']='Paiement mobile par '.$typePaiement;
        $parameters['body']='username: '.$this->getUser()->getUsername().'        ****        '.
                            'montant: '.$mtn.' FCFA     ****      '.
                            'type de paiement: '.$typePaiement.'        ****         '.
                            'numero de telephone: '.$tel.'      ****     '.
                            'ID transaction: '.$idTransaction;

        $event = new NotifyEvent($this->getUser(), $parameters);
        $dispatcher->dispatch(RingCoinEvents::SEND_SIMPLE_MAIL, $event);

        $request->getSession()
            ->getFlashBag()
            ->add('toast_success', 'backoffice.msgFlash.transactionPending');

        return $this->redirectToRoute('fos_user_profile_show');

    }

    public function checkPayment()
    {

        $client = $this->get('ring_coin_app.authentication')->authenticateCoinBaseApi($this->getParameter('cle_api_coinbase'), $this->getParameter('cle_secrete_coinbase'));
        $em = $this->getDoctrine()->getManager();
        $user = $em->getRepository(User::class)->find($this->getUser()->getId());
        $resp='empty';


        $repTransactions = $em->getRepository(Transactions::class)
            ->findBy(array('user'=>$user, 'statu'=>'pending', 'type'=>'achat'));

        if ($repTransactions!=null){
            foreach ($repTransactions as $repTransaction ){

                $transactionsUser = $this->get('ring_coin_app.authentication')->getCoinBaseTransactionsUser($repTransaction->getTypeAdr(), $repTransaction->getAdrTransaction());

                foreach ($transactionsUser as $transaction){
                    if ($transaction['network']['hash']==$repTransaction->getMotif()){

                        if ($transaction['status']=='completed'){
                            $repTransaction->setStatu($transaction['status']);

                            if ($user->getParrain()){
                                $transactionParrain = new Transactions();
                                $transactionParrain->setStatu('completed');
                                $transactionParrain->setMotif('backoffice.motifparrainage');
                                $transactionParrain->setNbrePieces(($repTransaction->getNbrePieces()*5)/100);
                                $transactionParrain->setUser($user->getParrain());
                                $transactionParrain->setType('bonus');
                                $user->getParrain()->setPiecesBonus(($repTransaction->getNbrePieces()*5)/100);
                                $user->getParrain()->addTransaction($transactionParrain);
                                $em->persist($user->getParrain());
                                $em->persist($transactionParrain);

                            }

                            $user->setPiecesAchete($repTransaction->getNbrePieces());
                            $resp='completed';
                        }elseif ($transaction['status']=='pending'){
                            $repTransaction->setStatu($transaction['status']);
                            $resp='pending';
                        }else{
                            $repTransaction->setStatu($transaction['status']);
                            $resp='pending';
                        }

                    }
                }
            }
        }

        $em->persist($user);
        $em->flush();

        return $resp;
    }


    /**
     * @return Response
     * @Route("/admin/listUsers", name="backoffice_admin_list_users")
     * @Security("has_role('ROLE_USER')")
     * @Method({"GET"})
     */
    public function listUsersAction(){
        $em = $this->getDoctrine()->getManager();

        $listUsers = $em->getRepository('RingCoinAppBundle:User')->findAll();

        return $this->render('RingCoinAppBundle:Backoffice:listUsers.html.twig', array('users'=>$listUsers));
    }

    /**
     * @return Response
     * @Route("/admin/resendConfirmation/{id}", name="resend_mail_confirmation", requirements={"id":"\d+"})
     * @Security("has_role('ROLE_USER')")
     * @Method({"GET"})
     */
    public function resendConfirmationAction(Request $request, $id){
        $em = $this->getDoctrine()->getManager();

        $user = $em->getRepository(User::class)->find($id);
        $token = $em->getRepository(User::class)->findOneByToken($user->getToken());

        $registrationController = new RegistrationController();
        $registrationController->confirmAction($request, $token);

        return $this->redirectToRoute('fos_user_registration_', array('request'=>$request, 'token'=>$token));
    }


    /**
     * Receive the confirmation token from user email provider, login the user.
     *
     * @param Request $request
     * @param string  $token
     * @Method({"GET"})
     *
     * @Route("/sendMailActivation/{token}", name="email_activation")
     * @Security("has_role('ROLE_USER')")
     * @return Response
     */
    public function confirmActivationEmailAction(Request $request, $token)
    {
        $em = $this->getDoctrine()->getManager();
        $toast = 'backoffice.msgFlash.profilAjour';

        $user = $em->getRepository(User::class)->findOneByConfirmationToken($token);

        if (null === $user) {
            throw new NotFoundHttpException(sprintf('The user with confirmation token "%s" does not exist', $token));
        }

        if ($user->isNewEdit()){
            $user->setPiecesBonus(5);
            $user->setNewEdit(false);

            $transaction = new Transactions();
            $transaction->setMotif('backoffice.motifRingBonus');
            $transaction->setType('bonus');
            $transaction->setUser($user);
            $transaction->setNbrePieces(5);
            $transaction->setStatu('completed');
            $user->addTransaction($transaction);

            $toast='backoffice.msgFlash.validateEmailConfirmed';

            $em = $this->getDoctrine()->getManager();
            $em->persist($transaction);
        }

        $user->setActive(true);
        $em->persist($user);
        $em->flush();

        $request->getSession()->getFlashBag()->add('toast_success', $toast);


        return $this->redirectToRoute('fos_user_profile_show');
    }

    /**
     * @param Request $request
     * @param $page
     *
     * @Method({"GET"})
     *
     * @Route("/paginateTransaction/{page}", name="paginate_transaction")
     */
    public function paginateTransaction(Request $request, $page){
        $em = $this->getDoctrine()->getManager();
        $transactions = $em->getRepository(Transactions::class)
            ->findBy(array('user'=>$this->getUser()), array('date'=>'desc'), 5, (5*$page)-5);

        return $this->render('RingCoinAppBundle:Backoffice:transactions.html.twig', array('transactions'=>$transactions));

    }


    /**
     * Tell the user to check their email provider.
     *
     * @Method({"GET"})
     *
     * @Route("/checkEmailActivation", name="check_email_validation")
     */
    public function checkEmailActivationAction(Request $request)
    {
        $email = $request->getSession()->get('email');
        return $this->render('@FOSUser/Registration/check_email.html.twig', array(
            'email' => $email,
        ));
    }


}