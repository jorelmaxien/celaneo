<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 02/11/17
 * Time: 19:48
 */

namespace RingCoin\AppBundle\Listeners;



use RingCoin\AppBundle\Events\TransactionEvent;
use RingCoin\AppBundle\Services\TransactionService;

class TransactionListener
{
    protected $transactions;

    public function __construct(TransactionService $transactions)
    {
        $this->transactions = $transactions;
    }

    public function addNewTransaction(TransactionEvent $event){
        $this->transactions->addTransaction($event->getType(), $event->getStatu(), $event->getMotif(), $event->getUser());
    }
}