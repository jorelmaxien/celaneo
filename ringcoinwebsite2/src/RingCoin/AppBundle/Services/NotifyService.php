<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 03/11/17
 * Time: 03:28
 */

namespace RingCoin\AppBundle\Services;


use Symfony\Component\Security\Core\User\UserInterface;

class NotifyService
{

    public function notifyConnection(UserInterface $user, \Swift_Mailer $mailer){
        //var_dump('new login user: '.$user->getUsername()) ;
    }

}