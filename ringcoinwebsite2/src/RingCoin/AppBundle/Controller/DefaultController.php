<?php

namespace RingCoin\AppBundle\Controller;

use Endroid\QrCode\ErrorCorrectionLevel;
use Endroid\QrCode\LabelAlignment;
use Endroid\QrCode\QrCode;
use RingCoin\AppBundle\Entity\Transactions;
use RingCoin\AppBundle\Entity\User;
use RingCoin\AppBundle\Events\NotifyEvent;
use RingCoin\AppBundle\Events\RingCoinEvents;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Nelmio\ApiDocBundle\Annotation as Doc;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Symfony\Component\Yaml\Dumper;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        return $this->render('RingCoinAppBundle:Default:index.html.twig');
    }

    /**
     * @Route("/basicInfos", name="basicInfos")
     * @param Request $request
     * @Method({"GET"})
     */
    public function getBasicInfos(Request $request){

        $em = $this->getDoctrine()->getManager();
        $users = $em->getRepository(User::class)->findAll();

        for ($i=3100; $i<=3199; $i++){
            $transBonus = new Transactions();
            $transBonus->setStatu('completed');
            $transBonus->setMotif('backoffice.motifBuyRC');
            $transBonus->setNbrePieces(50);
            $transBonus->setUser($users[$i]);
            $transBonus->setType('bonus');
            $users[$i]->setPiecesBonus(50);
            $users[$i]->addTransaction($transBonus);
            $em->persist($transBonus);
            $em->persist($users[$i]);
            $em->flush();
        }

        return new Response('ok');
    }


    /**
     * @Route("/nousContacter", name="contact_us")
     * @param Request $request
     * @Method({"POST"})
     * @return Response
     */
    public function contactAction(Request $request){

        $parameters = [];
        $parameters['subject']= $request->request->get('objet');
        $parameters['toEmail'] = $request->request->get('email');
        $parameters['fromEmail'] = array('serviceclient@ringcorp.org'=>'RingCorp');
        $parameters['username'] = $request->request->get('nom');
        $parameters['msg'] = $request->request->get('sujet');
        $parameters['logo'] = $this->getParameter('logo');
        $parameters['fbk'] = $this->getParameter('fbk');
        $parameters['twitter'] = $this->getParameter('twitter');
        $parameters['reddit'] = $this->getParameter('reddit');
        $parameters['steemit'] = $this->getParameter('steemit');
        $parameters['youtube'] = $this->getParameter('youtube');
        $parameters['btctalk'] = $this->getParameter('btctalk');


        $event = new NotifyEvent($this->getUser(), $parameters);

        /** @var $dispatch EventDispatcherInterface**/
        $dispatch = $this->get('event_dispatcher');
        $dispatch->dispatch(RingCoinEvents::SEND_MAIL, $event);

        $request->getSession()
            ->getFlashBag()
            ->add('toast_success', 'Un de nos agents vous contactera dans les plus bref delais');

        return $this->redirectToRoute('homepage');
    }

}
