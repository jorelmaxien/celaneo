<?php
/**
 * Created by IntelliJ IDEA.
 * User: wilson
 * Date: 24/10/17
 * Time: 16:41
 */

namespace RingCoin\AppBundle\Controller;


use Coinbase\Wallet\Enum\Param;
use Coinbase\Wallet\Resource\Account;
use Coinbase\Wallet\Resource\Address;
use Coinbase\Wallet\Client;
use Coinbase\Wallet\Resource\Transaction;
use Doctrine\DBAL\Types\JsonArrayType;
use JMS\Serializer\SerializerBuilder;
use RingCoin\AppBundle\Entity\Transactions;
use RingCoin\AppBundle\Entity\User;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Security\Core\Role\Role;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;
use Nelmio\ApiDocBundle\Annotation as Doc;


class UserController extends Controller
{
    /**
     * @Doc\ApiDoc(
     *     resource=true,
     *     description="Permet de parrainer un nouveau user",
     *     requirements={
     *        {
     *          "name"="code",
     *           "dataType"="string",
     *           "requirement"=".+",
     *           "description"="code de parrainnage du user"
     *        }
     *     },
     *     section="Parrainage"
     * )
     * @Route("/parrainage/{code}", name="parrainage", requirements={"code":".+"})
     * @Method({"GET"})
     */
    public function parrainageAction(Request $request, $code)
    {
        if ($this->get('security.authorization_checker')->isGranted('ROLE_USER'))
            return $this->redirectToRoute('fos_user_profile_show');

        $em = $this->getDoctrine()->getManager();
        $user = $em->getRepository('RingCoinAppBundle:User')->findOneBy(['lienParrainage' => $code]);

        if($user === null){
            throw new BadRequestHttpException("Ce lien n'est pas valide.");
        }else if ($user === $this->getUser()){
            throw new BadRequestHttpException('Impossible de se parrainer soit meme');
        }

        $this->get('session')->set('parrain_id', $user->getId());
        $this->get('session')->set('parrain_name', $user->getUsername());
        return $this->redirectToRoute('fos_user_registration_register');
    }

    /**
     * @Doc\ApiDoc(
     *     resource=true,
     *     description="Permet de generer une adresse de depot d'argent pour le user",
     *     statusCodes={200="Retourne en cas de succes"},
     *     requirements={
     *        {
     *          "name"="typeAdress",
     *           "dataType"="string",
     *           "requirement"="BTC|LTC|ETH",
     *           "description"="type d'addresse a generer"
     *        }
     *     },
     *     section="Deposit"
     * )
     * @Route("/generateDepositAdress/{typeAdress}", name="generateDepositAdress", requirements={"typeAdress":"BTC|LTC|ETH"})
     * @Method({"GET"})
     *
     * @param Request $request
     * @param $typeAdress
     */
    public function generateDepositAdressAction(Request $request, $typeAdress)
    {

        $em = $this->getDoctrine()->getManager();
        $user = $em->getRepository('RingCoinAppBundle:User')->find($this->getUser()->getId());
        $adr = new Address();
        $client = $this->get('ring_coin_app.authentication')->authenticateCoinBaseApi($this->getParameter('cle_api_coinbase'), $this->getParameter('cle_secrete_coinbase'));

        if ($typeAdress=='BTC'){

            $wallet = $client->getPrimaryAccount();

            $client->createAccountAddress($wallet, $adr);
            $user->setAdrBTC($adr->getAddress());

        }else if ($typeAdress=='LTC'){

            $wallet = $client->getAccounts()[0];

            $client->createAccountAddress($wallet, $adr);
            $user->setAdrLTC($adr->getAddress());

        }else if ($typeAdress=='ETH'){

            $wallet = $client->getAccounts()[1];

            $client->createAccountAddress($wallet, $adr);
            $user->setAdrETH($adr->getAddress());
        }

        $em->persist($user);
        $em->flush();

        if ($request->isXmlHttpRequest()){
            return new JsonResponse(array('depositAdress'=>$adr->getAddress()), Response::HTTP_OK);
        }
        return $this->redirectToRoute('backoffice_deposit');

    }

    /**
     * @Doc\ApiDoc(
     *     resource=true,
     *     description="Permet de generer le lien de parrainage d1 user",
     *     section="Parrainage"
     * )
     * @Route("/getLienParrainage", name="parrainage_link")
     * @Security("has_role('ROLE_USER')")
     * @Method({"GET"})
     */
    public function getLienParrainageAction(Request $request)
    {
        /*if(!$request->isXmlHttpRequest())
            throw new BadRequestHttpException();*/

        $em = $this->getDoctrine()->getManager();
        $code = $this->get('ring_coin_app.cryptage')->getCode(9, false, true);
        $this->getUser()->setLienParrainage($code);

        //$url = $this->generateUrl('parrainage', ['code' => $code], true);
        $em->persist($this->getUser());
        $em->flush();

        return $this->redirectToRoute('fos_user_profile_show');
    }


    /**
     * action validant le depot de l'argent
     * @Route("/deposit/checkPayment", name="check_payment")
     * @Method({"GET"})
     * @param Request $request
     */
    public function checkPayment(Request $request)
    {

        $client = $this->get('ring_coin_app.authentication')->authenticateCoinBaseApi($this->getParameter('cle_api_coinbase'), $this->getParameter('cle_secrete_coinbase'));
        $user = $this->getUser();
        $em = $this->getDoctrine()->getManager();
        //$user = $em->getRepository(User::class)->find(1);
        $resp='empty';

        if (!$request->isXmlHttpRequest()){
            throw new AccessDeniedHttpException('Impossible d\'acceder depuis le naviguateur');
        }


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
                                $transactionParrain->setMotif('Grace au parrainage');
                                $transactionParrain->setNbrePieces(($repTransaction->getNbrePieces()*5)/100);
                                $transactionParrain->setUser($user->getParrain());
                                $transactionParrain->setType('bonus');
                                $user->getParrain()->setPiecesBonus(($repTransaction->getNbrePieces()*5)/100);
                                $user->getParrain()->addTransaction($transaction);
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

        return new JsonResponse(array('resp'=>$resp));
    }
}