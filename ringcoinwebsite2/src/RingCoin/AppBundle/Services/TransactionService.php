<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 02/11/17
 * Time: 19:55
 */

namespace RingCoin\AppBundle\Services;


use Doctrine\ORM\EntityManager;
use FOS\UserBundle\Model\UserInterface;
use RingCoin\AppBundle\Entity\User;

class TransactionService
{
    protected $em;

    public function __construct(EntityManager $em)
    {
      $this->em = $em;
    }

    public function addTransaction($typeTransaction, $statu, $motif, User $user){
        $transaction  = new \RingCoin\AppBundle\Entity\Transactions();
        $transaction->setMotif($motif);
        $transaction->setStatu($statu);
        $transaction->setType($typeTransaction);
        $transaction->setUser($user);
        $user->addTransaction($transaction);

        $this->em->persist($transaction);
        $this->em->flush();
    }

    public function updateTransaction($id){
        $transaction = $this->em->getRepository('RingCoinAppBundle:Transactions')->find($id);
        $transaction->
        $this->em->flush();
    }

}