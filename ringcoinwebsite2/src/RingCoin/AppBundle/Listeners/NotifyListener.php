<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 03/11/17
 * Time: 03:32
 */

namespace RingCoin\AppBundle\Listeners;


use FOS\UserBundle\Mailer\TwigSwiftMailer;
use FOS\UserBundle\Util\TokenGenerator;
use FOS\UserBundle\Util\TokenGeneratorInterface;
use RingCoin\AppBundle\Events\NotifyEvent;
use RingCoin\AppBundle\Services\NotifyService;
use Symfony\Component\Security\Core\Event\AuthenticationEvent;
use Symfony\Component\Security\Core\Security;

class NotifyListener
{
    protected  $twig_mailer, $swift_Mailer, $tokenGenerator;

    /**
     * NotifyListener constructor.
     * @param $authEvent
     */
    public function __construct(TwigSwiftMailer $twig_mailer, \Swift_Mailer $swift_Mailer, TokenGeneratorInterface $tokenGenerator)
    {
        $this->twig_mailer = $twig_mailer;
        $this->tokenGenerator = $tokenGenerator;
        $this->swift_Mailer = $swift_Mailer;
    }

    /*public function notifyUserConnected(AuthenticationEvent $authEvent){
        $user = $authEvent->getAuthenticationToken()->getUser();
        //var_dump($user);
        if (!is_string($user))
        $this->notifyService->notifyConnection($user,$this->mailer);
    }*/

    public function sendMail(NotifyEvent $notifyEvent){
        $this->twig_mailer->sendEmail($notifyEvent->getData());
    }

    public function sendSimpleMail(NotifyEvent $notifyEvent){
        $this->swift_Mailer->send($notifyEvent->getMessageOfMail());
    }

    public function sendEmailActivation(NotifyEvent $notifyEvent){
        $user = $notifyEvent->getUser();

        if (null === $user->getConfirmationToken()) {
            $user->setConfirmationToken($this->tokenGenerator->generateToken());
        }

        $this->twig_mailer->sendActiveEmailMessage($user, $notifyEvent->getData());
    }

}