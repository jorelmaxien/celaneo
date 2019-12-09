<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 03/11/17
 * Time: 03:30
 */

namespace RingCoin\AppBundle\Events;


use Swift_Mailer;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\EventDispatcher\Event;

class NotifyEvent extends Event
{
    protected $user;

    protected $data;

    /**
     * NotifyEvent constructor.
     * @param $user
     * @param $data
     */
    public function __construct($user, $data)
    {
        $this->user = $user;
        $this->data = $data;
    }

    public function getMessageOfMail(){
        $msg = \Swift_Message::newInstance()
                ->setSubject($this->data['subject'])
                ->setFrom($this->data['fromEmail'])
                ->setTo($this->data['toEmail'])
                ->setBody($this->data['body'], 'text/plain', 'UTF-8');

        return $msg;
    }

    /**
     * @return mixed
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * @param mixed $user
     */
    public function setUser($user)
    {
        $this->user = $user;
    }

    /**
     * @return mixed
     */
    public function getData()
    {
        return $this->data;
    }

    /**
     * @param mixed $data
     */
    public function setData($data)
    {
        $this->data = $data;
    }


}