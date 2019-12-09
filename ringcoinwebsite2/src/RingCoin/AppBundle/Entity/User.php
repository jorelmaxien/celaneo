<?php

namespace RingCoin\AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;
use FOS\UserBundle\Model\User as BaseUser;

/**
 * User
 *
 * @ORM\Table(name="user")
 * @ORM\Entity(repositoryClass="RingCoin\AppBundle\Repository\UserRepository")
 */
class User extends BaseUser
{
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @var string
     *
     * @ORM\Column(name="google_id", type="string", nullable=true)
     */
    protected $google_id;

    /**
     * @var string
     *
     * @ORM\Column(name="lien_parrainage", type="string", nullable=true)
     */
    protected $lienParrainage;

    /**
     * @var string
     *
     * @ORM\Column(name="adr_btc", type="string", nullable=true)
     */
    protected $adrBTC;

    /**
     * @var string
     *
     * @ORM\Column(name="adr_ltc", type="string", nullable=true)
     */
    protected $adrLTC;

    /**
     * @var string
     *
     * @ORM\Column(name="adr_eth", type="string", nullable=true)
     */
    protected $adrETH;

    /**
     * @var string
     *
     * @ORM\Column(name="pieces_bonus", type="decimal", precision=10, scale=4)
     */
    protected $piecesBonus;

    /**
     * @var string
     *
     * @ORM\Column(name="pieces_achete", type="decimal", precision=10, scale=4)
     */
    protected $piecesAchete;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="date_inscription", type="date", nullable=false)
     */
    protected $dateInscription;

    /**
     * @var boolean
     *
     * @ORM\Column(name="active", type="boolean")
     */
    protected $active;

    /**
     * @var boolean
     *
     * @ORM\Column(name="new_edit", type="boolean")
     */
    protected $newEdit;

    /**
     * @var string
     *
     * @ORM\Column(name="nivo_experience", type="string", nullable=false)
     */
    protected $nivoExperience;

    /**
     * @ORM\ManyToOne(targetEntity="User",inversedBy="filleuls", cascade={"persist"})
     * @ORM\JoinColumn(nullable=true)
     */
    protected $parrain;

    /**
     * @ORM\OneToMany(targetEntity="User", mappedBy="parrain", cascade={"persist"})
     */
    protected $filleuls;

    /**
     * @ORM\OneToMany(targetEntity="Transactions", mappedBy="user", cascade={"persist"})
     */
    protected $transactions;

    public function __construct()
    {
        parent::__construct();
        $this->piecesBonus=0;
        $this->piecesAchete=0;
        $this->active = false;
        $this->newEdit = true;
        $this->nivoExperience = 'debutant';
        $this->dateInscription = new \DateTime('now', new \DateTimeZone('Africa/Douala'));
        //$this->media = new \Doctrine\Common\Collections\ArrayCollection();
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
     * Set googleId
     *
     * @param string $googleId
     *
     * @return User
     */
    public function setGoogleId($googleId)
    {
        $this->google_id = $googleId;

        return $this;
    }

    /**
     * Get googleId
     *
     * @return string
     */
    public function getGoogleId()
    {
        return $this->google_id;
    }

    /**
     * Set lienParrainage
     *
     * @param string $lienParrainage
     *
     * @return User
     */
    public function setLienParrainage($lienParrainage)
    {
        $this->lienParrainage = $lienParrainage;

        return $this;
    }

    /**
     * Get lienParrainage
     *
     * @return string
     */
    public function getLienParrainage()
    {
        return $this->lienParrainage;
    }

    /**
     * Set parrain
     *
     * @param \RingCoin\AppBundle\Entity\User $parrain
     *
     * @return User
     */
    public function setParrain(\RingCoin\AppBundle\Entity\User $parrain = null)
    {
        $this->parrain = $parrain;

        return $this;
    }

    /**
     * Get parrain
     *
     * @return \RingCoin\AppBundle\Entity\User
     */
    public function getParrain()
    {
        return $this->parrain;
    }

    /**
     * Set active
     *
     * @param boolean $active
     *
     * @return User
     */
    public function setActive($active)
    {
        $this->active = $active;

        return $this;
    }

    /**
     * Get active
     *
     * @return boolean
     */
    public function getActive()
    {
        return $this->active;
    }

    /**
     * Set adrBTC
     *
     * @param string $adrBTC
     *
     * @return User
     */
    public function setAdrBTC($adrBTC)
    {
        $this->adrBTC = $adrBTC;

        return $this;
    }

    /**
     * Get adrBTC
     *
     * @return string
     */
    public function getAdrBTC()
    {
        return $this->adrBTC;
    }

    /**
     * Set adrLTC
     *
     * @param string $adrLTC
     *
     * @return User
     */
    public function setAdrLTC($adrLTC)
    {
        $this->adrLTC = $adrLTC;

        return $this;
    }

    /**
     * Get adrLTC
     *
     * @return string
     */
    public function getAdrLTC()
    {
        return $this->adrLTC;
    }

    /**
     * Set adrETH
     *
     * @param string $adrETH
     *
     * @return User
     */
    public function setAdrETH($adrETH)
    {
        $this->adrETH = $adrETH;

        return $this;
    }

    /**
     * Get adrETH
     *
     * @return string
     */
    public function getAdrETH()
    {
        return $this->adrETH;
    }

    /**
     * Set dateInscription
     *
     * @param \dateTime $dateInscription
     *
     * @return User
     */
    public function setDateInscription(\dateTime $dateInscription)
    {
        $this->dateInscription = $dateInscription;

        return $this;
    }

    /**
     * Get dateInscription
     *
     * @return \dateTime
     */
    public function getDateInscription()
    {
        return $this->dateInscription;
    }

    /**
     * Set nivoExperience
     *
     * @param string $nivoExperience
     *
     * @return User
     */
    public function setNivoExperience($nivoExperience)
    {
        $this->nivoExperience = $nivoExperience;

        return $this;
    }

    /**
     * Get nivoExperience
     *
     * @return string
     */
    public function getNivoExperience()
    {
        return $this->nivoExperience;
    }


    /**
     * Add transaction
     *
     * @param \RingCoin\AppBundle\Entity\Transactions $transaction
     *
     * @return User
     */
    public function addTransaction(\RingCoin\AppBundle\Entity\Transactions $transaction)
    {
        $this->transactions[] = $transaction;

        return $this;
    }

    /**
     * Remove transaction
     *
     * @param \RingCoin\AppBundle\Entity\Transactions $transaction
     */
    public function removeTransaction(\RingCoin\AppBundle\Entity\Transactions $transaction)
    {
        $this->transactions->removeElement($transaction);
    }

    /**
     * Get transactions
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getTransactions()
    {
        return $this->transactions;
    }

    /**
     * Set newEdit
     *
     * @param boolean $newEdit
     *
     * @return User
     */
    public function setNewEdit($newEdit)
    {
        $this->newEdit = $newEdit;

        return $this;
    }

    /**
     * Get newEdit
     *
     * @return boolean
     */
    public function isNewEdit()
    {
        return $this->newEdit;
    }

    /**
     * Set piecesBonus
     *
     * @param string $piecesBonus
     *
     * @return User
     */
    public function setPiecesBonus($piecesBonus)
    {
        $this->piecesBonus += doubleval($piecesBonus);

        return $this;
    }

    /**
     * Get piecesBonus
     *
     * @return string
     */
    public function getPiecesBonus()
    {
        return $this->piecesBonus;
    }

    /**
     * Set piecesAchete
     *
     * @param string $piecesAchete
     *
     * @return User
     */
    public function setPiecesAchete($piecesAchete)
    {
        $this->piecesAchete += doubleval($piecesAchete);

        return $this;
    }

    /**
     * Get piecesAchete
     *
     * @return string
     */
    public function getPiecesAchete()
    {
        return $this->piecesAchete;
    }

    /**
     * Get newEdit
     *
     * @return boolean
     */
    public function getNewEdit()
    {
        return $this->newEdit;
    }

    /**
     * Add filleul
     *
     * @param \RingCoin\AppBundle\Entity\User $filleul
     *
     * @return User
     */
    public function addFilleul(\RingCoin\AppBundle\Entity\User $filleul)
    {
        $this->filleuls[] = $filleul;

        return $this;
    }

    /**
     * Remove filleul
     *
     * @param \RingCoin\AppBundle\Entity\User $filleul
     */
    public function removeFilleul(\RingCoin\AppBundle\Entity\User $filleul)
    {
        $this->filleuls->removeElement($filleul);
    }

    /**
     * Get filleuls
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getFilleuls()
    {
        return $this->filleuls;
    }
}
