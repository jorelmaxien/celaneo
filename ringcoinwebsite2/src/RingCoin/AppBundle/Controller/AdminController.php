<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 29/11/17
 * Time: 16:14
 */

namespace RingCoin\AppBundle\Controller;


use FOS\UserBundle\Model\UserManagerInterface;
use JMS\Serializer\Serializer;
use JMS\Serializer\SerializerBuilder;
use RingCoin\AppBundle\Entity\Transactions;
use RingCoin\AppBundle\Entity\User;

use RingCoin\AppBundle\Events\NotifyEvent;
use RingCoin\AppBundle\Events\RingCoinEvents;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;

/**
 * Class AdminController
 * @package RingCoin\AppBundle\Controller
 * @Route("/dashboard")
 * @Security("has_role('ROLE_ADMIN')")
 */
class AdminController extends Controller
{

    /**
     * @return Response
     * @Route("/newsletter", name="newsletter")
     * @Method({"POST", "GET"})
     */
    public function newsLetter(Request $request){

        if ($request->isMethod('post')){

            $parameters = [];
            $parameters['logo'] = $this->getParameter('logo');
            $parameters['fbk'] = $this->getParameter('fbk');
            $parameters['twitter'] = $this->getParameter('twitter');
            $parameters['reddit'] = $this->getParameter('reddit');
            $parameters['steemit'] = $this->getParameter('steemit');
            $parameters['youtube'] = $this->getParameter('youtube');
            $parameters['btctalk'] = $this->getParameter('btctalk');


            $em = $this->getDoctrine()->getManager();

            /** @var $dispatcher EventDispatcherInterface */
            $dispatcher = $this->get('event_dispatcher');
            $data = [];


               /* $parameters['subject'] = $request->request->get('objet');
                $parameters['toEmail'] = 'fonkouwilliam90@gmail.com';
                $parameters['fromEmail'] = array('noreply@zoomconnect.net'=>'RingCorp');
                $parameters['username'] = 'wil';
                $parameters['msg'] = $request->request->get('sujet');

                $event = new NotifyEvent(null, $parameters);
                $dispatcher->dispatch(RingCoinEvents::SEND_MAIL, $event);
*/

            $parameters['subject'] = $request->request->get('objet');
            $parameters['msg'] = $request->request->get('sujet');

            $users = $em->getRepository(User::class)->findAll();
           

            for ($i=1100; $i<=1199; $i++){
                var_dump($users[$i]->getEmail());

                $parameters['toEmail'] = $users[$i]->getEmail();
                $parameters['fromEmail'] = array('noreply@ringcorp.net'=>'RingCorp');
                $parameters['username'] = $users[$i]->getUsername();

                $event = new NotifyEvent($users[$i], $parameters);
                $dispatcher->dispatch(RingCoinEvents::SEND_MAIL, $event);
            }

            $request->getSession()
                ->getFlashBag()
                ->add('toast_success', 'Envoie des mails reussi');
            return new Response('ok');

            //return $this->redirectToRoute('newsletter');

        }

        return $this->render('RingCoinAppBundle:Backoffice:newsletter.html.twig');
    }

    /**
     * @return Response
     * @Route("/crediteAccount", name="backoffice_admin_credite")
     */
    public function crediteAccount(Request $request){
        $em = $this->getDoctrine()->getManager();

        if ($request->isMethod('POST')){
            $username = $request->request->get('username');
            $somme = $request->request->get('somme');
            $adrTransaction = $request->request->get('adrTransaction');
            $motif = $request->request->get('motif');
            $typeAdr = $request->request->get('typeAdr');
            $typeCreditation = $request->request->get('typeCreditation');
            /** @var $userManager UserManagerInterface **/
            $userManager = $this->get('fos_user.user_manager');

            $user = $userManager->findUserByUsername($username);
            $motifExist = $em->getRepository(Transactions::class)->findOneByMotif($motif);

            if ($motifExist!=null){
                $request->getSession()
                    ->getFlashBag()
                    ->add('toast_success', 'Creditation du compte impossible car l\'ID transaction existe deja');
                return $this->redirectToRoute('backoffice_admin_credite');
            }

            $transaction = new Transactions();
            $transaction->setUser($user);
            $transaction->setType('achat');
            $transaction->setStatu('completed');
            $transaction->setAdrTransaction($adrTransaction);
            $transaction->setTypeAdr($typeAdr);
            $transaction->setNbrePieces($somme/$this->getParameter('prixRC'));
            $transaction->setMotif($motif);

            $transBonus = new Transactions();
            $transBonus->setStatu('completed');
            $transBonus->setMotif('backoffice.motifBuyRC');
            if ($somme<200){
                $transBonus->setNbrePieces($transaction->getNbrePieces());
            }else{
                $transBonus->setNbrePieces($transaction->getNbrePieces()*2);
            }
            $transBonus->setUser($user);
            $transBonus->setType('bonus');
            $user->setPiecesBonus($transBonus->getNbrePieces());

            $user->addTransaction($transBonus);
            $user->addTransaction($transaction);
            $user->setPiecesAchete($transaction->getNbrePieces());
            $em->persist($transaction);
            $em->persist($transBonus);
            $em->flush();

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
                $em->flush();
            }

            $request->getSession()
                ->getFlashBag()
                ->add('toast_success', 'Creditation du compte reussi');

        }

        return $this->render('RingCoinAppBundle:Backoffice:crediteAccount.html.twig');

    }

    /**
     * @return Response
     * @Route("/", name="backoffice_admin_homepage")
     */
    public function adminHomePageAction(Request $request){
        $em = $this->getDoctrine()->getManager();

        $listUsers = $em->getRepository(User::class)->findBy(array(), array('dateInscription'=>'ASC'));
        $data['tt_users_actifs'] = count($em->getRepository(User::class)->findByActive(true));
        $data['tt_users_non_actifs'] = count($em->getRepository(User::class)->findByActive(false));

        $data['tt_users'] = count($listUsers);
        $data['tt_transactions'] = count($em->getRepository('RingCoinAppBundle:Transactions')->findAll());
        $piecesAchetes = 0; $piecesBonus=0;

        $dateInscriptions = [];
        $nbreInscr = [];
        $dateInscr = [];
        $nbre = [];

        foreach ($listUsers as $user){
            $piecesAchetes +=$user->getPiecesAchete();
            $piecesBonus +=$user->getPiecesBonus();

            $key = strval(date_format($user->getDateInscription(),'d-M'));

            $dates[] = $key;
            if (!array_key_exists($key, $dateInscriptions)){
                $dateInscriptions[$key] = $key;
                $nbreInscr[$key] = count($em->getRepository(User::class)
                                        ->findByDateInscription($user->getDateInscription()));
            }
        }

        $dateInscr[0] = 0;
        $nbre[0] = 0;
        foreach ($dateInscriptions as $date){
            $dateInscr[]=$date;
        }

        foreach ($nbreInscr as $nbr){
            $nbre[] = $nbr;
        }


        $data['piecesBonus'] = $piecesBonus;
        $data['piecesAchetes'] = $piecesAchetes;

        $dataJS = array(
            'dateInscr'=>$dateInscr,
            'nbreInscr'=>$nbre
        );

        if ($request->isXmlHttpRequest()){
            return new JsonResponse($dataJS);
        }

        return $this->render('RingCoinAppBundle:Backoffice:admin_homepage.html.twig', array('data'=>$data));
    }

}
