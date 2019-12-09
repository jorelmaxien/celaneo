<?php

/*
 * This file is part of the FOSUserBundle package.
 *
 * (c) FriendsOfSymfony <http://friendsofsymfony.github.com/>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace RingCoin\AppBundle\Controller;

use Endroid\QrCode\ErrorCorrectionLevel;
use Endroid\QrCode\LabelAlignment;
use Endroid\QrCode\QrCode;
use FOS\UserBundle\Event\FilterUserResponseEvent;
use FOS\UserBundle\Event\FormEvent;
use FOS\UserBundle\Event\GetResponseUserEvent;
use FOS\UserBundle\Form\Factory\FactoryInterface;
use FOS\UserBundle\FOSUserEvents;
use FOS\UserBundle\Model\UserInterface;
use FOS\UserBundle\Model\UserManagerInterface;
use RingCoin\AppBundle\Entity\Transactions;
use RingCoin\AppBundle\Entity\User;
use RingCoin\AppBundle\Events\NotifyEvent;
use RingCoin\AppBundle\Events\RingCoinEvents;
use RingCoin\AppBundle\Events\TransactionEvent;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

/**
 * Controller managing the user profile.
 *
 * @author Christophe Coevoet <stof@notk.org>
 */
class ProfileController extends Controller
{
    /**
     * Show the user.
     */
    public function showAction(Request $request)
    {
        $user = $this->getUser();
        $em = $this->getDoctrine()->getManager();
        $prixRC=0;
        $totalPiecesVendues=0;
        $start = new \DateTime();
        $end = new \DateTime();


        if (!is_object($user) || !$user instanceof UserInterface) {
            throw new AccessDeniedException('This user does not have access to this section.');
        }

        if ($user->getRoles()=='ROLE_ADMIN')
            return $this->redirectToRoute('backoffice_admin_homepage');


        $currentDate =  new \DateTime('now', new \DateTimeZone('Africa/Douala'));

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

        if ($currentDate<$dateFirst){
            $prixRC = 0.085;
        }else if ($currentDate>=$dateFirst && $currentDate<=$dateSecond){
            $prixRC = 0.4;
        }else if ($currentDate>$dateSecond && $currentDate<=$dateThird){
            $prixRC = 0.7;
        }

        $data['prixRC']=$prixRC;
        $data['totalPiecesVendues']=$totalPiecesVendues;
        $data['fileParameter']=$this->getParameter('kernel.project_dir').'/app/config/app_parameters.yml';

        $this->get('ring_coin_app.authentication')->writeParameter($data);

        /*$this->getQrCode($user->getAdrBTC());
        $this->getQrCode($user->getAdrLTC());
        $this->getQrCode($user->getAdrETH());*/

        $transactions = $em->getRepository(Transactions::class)
                            ->findBy(array('user'=>$this->getUser()), array('date'=>'desc'), 5);

        $allTransactions = $em->getRepository(Transactions::class)
            ->findBy(array('user'=>$this->getUser()));


        $nbreFilleuls = $em->getRepository(User::class)->findBy(
            array('parrain'=>$this->getUser())
        );


        if ($this->get('security.authorization_checker')->isGranted('ROLE_ADMIN')){
            return $this->redirectToRoute('backoffice_admin_homepage');
        }



        /** @var $formFactory FactoryInterface */
        $formFactory = $this->get('fos_user.profile.form.factory');

        $form = $formFactory->createForm();
        $form->setData($user);

        $form->handleRequest($request);


        $data = [];
        $data['form'] = $form->createView();
        $data['user'] = $user;
        $data['prixRC'] = $prixRC;
        $data['nbreFilleuls'] = count($nbreFilleuls);
        $data['transactions'] = $transactions;
        $nbrePages = [];

        for ($i=0;$i<=count($allTransactions)/5;$i++){
            $nbrePages[$i] = $i;
        }

        $data['nbrePages'] = $nbrePages;

        return $this->render('@FOSUser/Profile/show.html.twig', array(
           'data'=> $data
        ));
    }


    public function getQrCode($adr){
        $qrCode = new QrCode($adr);
        $qrCode->setSize(300);

        // Set advanced options
        $qrCode
            ->setWriterByName('png')
            ->setMargin(10)
            ->setEncoding('UTF-8')
            ->setErrorCorrectionLevel(ErrorCorrectionLevel::HIGH)
            ->setForegroundColor(['r' => 0, 'g' => 0, 'b' => 0])
            ->setBackgroundColor(['r' => 255, 'g' => 255, 'b' => 255])
            ->setLabel('Scan the code', 16)
            ->setLabelAlignment(LabelAlignment::CENTER)
            ->setLogoPath($this->getParameter('logo'))
            ->setLogoWidth(50)
            ->setValidateResult(false)
            ->setSize(250)
        ;

        $qrCode->writeFile($this->getParameter('kernel.project_dir').'/web/bundles/ringcoinapp/qrcode/'.$adr.'.png');
        //return new Response($qrCode->writeString(), Response::HTTP_OK, array('Content-Type'=>'image/png'));
    }

    /**
     * Edit the user.
     *
     * @param Request $request
     *
     * @return Response
     */
    public function editAction(Request $request)
    {

        $user = $this->getUser();

        if (!is_object($user) || !$user instanceof UserInterface) {
            throw new AccessDeniedException('This user does not have access to this section.');
        }

        /** @var $dispatcher EventDispatcherInterface **/
        $dispatcher = $this->get('event_dispatcher');

        $event = new GetResponseUserEvent($user, $request);
        $dispatcher->dispatch(FOSUserEvents::PROFILE_EDIT_INITIALIZE, $event);

        if (null !== $event->getResponse()) {
            return $event->getResponse();
        }

        /** @var $formFactory FactoryInterface **/
        $formFactory = $this->get('fos_user.profile.form.factory');

        $form = $formFactory->createForm();
        $form->setData($user);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            /** @var $userManager UserManagerInterface **/
            $userManager = $this->get('fos_user.user_manager');

            $mail = $userManager->findUserByEmail($form->getData()->getEmail());
            $username = $userManager->findUserByEmail($form->getData()->getUsername());

            $event = new FormEvent($form, $request, array());
            $dispatcher->dispatch(FOSUserEvents::PROFILE_EDIT_SUCCESS, $event);


            $parameters = [];
            $parameters['logo'] = $this->getParameter('logo');
            $parameters['fbk'] = $this->getParameter('fbk');
            $parameters['twitter'] = $this->getParameter('twitter');
            $parameters['reddit'] = $this->getParameter('reddit');
            $parameters['steemit'] = $this->getParameter('steemit');
            $parameters['youtube'] = $this->getParameter('youtube');
            $parameters['btctalk'] = $this->getParameter('btctalk');


            if (null === $response = $event->getResponse()) {
                //$url = $this->generateUrl('fos_user_profile_show');
                if (!$user->getActive()){
                    $notifyEvent = new NotifyEvent($user, $parameters);
                    $dispatcher->dispatch(RingCoinEvents::EMAIL_ACTIVATION, $notifyEvent);

                    $request->getSession()->set('email', $user->getEmail());
                    $response = $this->redirectToRoute('check_email_validation');
                }else{
                    $request->getSession()->getFlashBag()->add('toast_success', 'backoffice.msgFlash.profilAjour');
                    $response = $this->redirectToRoute('fos_user_profile_show');
                }

            }

            $userManager->updateUser($user);

            $dispatcher->dispatch(FOSUserEvents::PROFILE_EDIT_COMPLETED, new FilterUserResponseEvent($user, $request, $response));

            return $response;
        }

        $data['form'] = $form->createView();

        return $this->redirectToRoute('fos_user_profile_show');

    }
}
