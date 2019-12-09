<?php

namespace RingCoin\AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

use Symfony\Component\Validator\Constraints as Assert;

/**
 * Transactions
 *
 * @ORM\Table(name="transactions")
 * @ORM\Entity(repositoryClass="RingCoin\AppBundle\Repository\TransactionsRepository")
 */
class Transactions
{
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="date", type="datetime")
     */
    private $date;

    /**
     * @var string
     *
     * @ORM\Column(name="statu", type="string", length=10)
     */
    private $statu;

    /**
     * @var string
     *
     * @ORM\Column(name="motif", type="string", length=255)
     */
    private $motif;

    /**
     * @var string
     *
     * @ORM\Column(name="type", type="string", length=10)
     */
    private $type;

    /**
     * @var string
     *
     * @ORM\Column(name="nbre_pieces", type="decimal", precision=10, scale=4)
     */
    private $nbrePieces;

    /**
     * @var string
     *
     * @ORM\Column(name="adr_transaction", type="string", length=255, nullable=true)
     */
    private $adrTransaction;

    /**
     * @var string
     *
     * @ORM\Column(name="type_adresse", type="string", length=4, nullable=true)
     */
    private $typeAdr;

    /**
     * @ORM\ManyToOne(targetEntity="User", inversedBy="transactions", cascade={"persist"})
     * @ORM\JoinColumn(nullable=true)
     * @Assert\Valid()
     * @Assert\Type("User")
     */
    protected $user;

    public function __construct()
    {
        $this->date = new \DateTime('now', new \DateTimeZone('Africa/Douala'));
    }

    /**
     * Get id
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set date
     *
     * @param \DateTime $date
     *
     * @return Transactions
     */
    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    /**
     * Get date
     *
     * @return \DateTime
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * Set statu
     *
     * @param string $statu
     *
     * @return Transactions
     */
    public function setStatu($statu)
    {
        $this->statu = $statu;

        return $this;
    }

    /**
     * Get statu
     *
     * @return string
     */
    public function getStatu()
    {
        return $this->statu;
    }

    /**
     * Set motif
     *
     * @param string $motif
     *
     * @return Transactions
     */
    public function setMotif($motif)
    {
        $this->motif = $motif;

        return $this;
    }

    /**
     * Get motif
     *
     * @return string
     */
    public function getMotif()
    {
        return $this->motif;
    }

    /**
     * Set type
     *
     * @param string $type
     *
     * @return Transactions
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * Get type
     *
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Set user
     *
     * @param \RingCoin\AppBundle\Entity\User $user
     *
     * @return Transactions
     */
    public function setUser(\RingCoin\AppBundle\Entity\User $user = null)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * Get user
     *
     * @return \RingCoin\AppBundle\Entity\User
     */
    public function getUser()
    {
        return $this->user;
    }


    /**
     * Set adrTransaction
     *
     * @param string $adrTransaction
     *
     * @return Transactions
     */
    public function setAdrTransaction($adrTransaction)
    {
        $this->adrTransaction = $adrTransaction;

        return $this;
    }

    /**
     * Get adrTransaction
     *
     * @return string
     */
    public function getAdrTransaction()
    {
        return $this->adrTransaction;
    }

    /**
     * Set typeAdr
     *
     * @param string $typeAdr
     *
     * @return Transactions
     */
    public function setTypeAdr($typeAdr)
    {
        $this->typeAdr = $typeAdr;

        return $this;
    }

    /**
     * Get typeAdr
     *
     * @return string
     */
    public function getTypeAdr()
    {
        return $this->typeAdr;
    }

    /**
     * Set nbrePieces
     *
     * @param string $nbrePieces
     *
     * @return Transactions
     */
    public function setNbrePieces($nbrePieces)
    {
        $this->nbrePieces = $nbrePieces;

        return $this;
    }

    /**
     * Get nbrePieces
     *
     * @return string
     */
    public function getNbrePieces()
    {
        return $this->nbrePieces;
    }
}
