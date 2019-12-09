<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 27/10/17
 * Time: 15:30
 */

namespace RingCoin\AppBundle\Events;


use Coinbase\Wallet\Client;
use Coinbase\Wallet\Configuration;
use Symfony\Component\EventDispatcher\Event;

class AuthenticateCoinbaseEvent extends Event
{

    protected $cleApi;
    protected $cleSecret;
    protected $client;

    /**
     * AuthenticateCoinbaseEvent constructor.
     * @param $cleApi
     * @param $cleSecret
     */
    public function __construct($cleApi, $cleSecret)
    {
        $this->cleApi = $cleApi;
        $this->cleSecret = $cleSecret;
    }

    public function authenticateCoinbaseApi(){
        $configuration = Configuration::apiKey($this->cleApi, $this->cleSecret);
        return $this->client = Client::create($configuration);
    }

    /**
     * @return mixed
     */
    public function getClient()
    {
        return $this->client;
    }

    /**
     * @return mixed
     */
    public function getCleApi()
    {
        return $this->cleApi;
    }

    /**
     * @return mixed
     */
    public function getCleSecret()
    {
        return $this->cleSecret;
    }

}