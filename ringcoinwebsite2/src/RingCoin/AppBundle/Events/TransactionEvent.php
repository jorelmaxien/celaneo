<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 02/11/17
 * Time: 19:51
 */

namespace RingCoin\AppBundle\Events;


use Symfony\Component\EventDispatcher\Event;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Core\User\UserInterface;

class TransactionEvent extends Event
{

    protected $user;
    protected $statu;
    protected $type;
    protected $motif;
    protected $request;

    /**
     * TransactionEvent constructor.
     * @param $user
     * @param $statu
     * @param $type
     * @param $motif
     */
    public function __construct($user, $statu, $type, $motif, Request $request)
    {
        $this->user = $user;
        $this->statu = $statu;
        $this->type = $type;
        $this->motif = $motif;
        $this->request = $request;
    }

    /**
     * @return mixed
     */
    public function getStatu()
    {
        return $this->statu;
    }

    public function setRequest(Request $request)
    {
         $this->request = $request;
    }

    /**
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }


    /**
     * @return mixed
     */
    public function getMotif()
    {
        return $this->motif;
    }


    public function getUser(){
        return $this->user;
    }

}