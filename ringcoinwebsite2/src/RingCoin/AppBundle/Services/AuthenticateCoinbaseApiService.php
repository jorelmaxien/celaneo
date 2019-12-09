<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 27/10/17
 * Time: 15:48
 */

namespace RingCoin\AppBundle\Services;


use Coinbase\Wallet\Client;
use Coinbase\Wallet\Configuration;

class AuthenticateCoinbaseApiService
{

    public function authenticateCoinbaseApi($cleApi, $cleSecret){
        $configuration = Configuration::apiKey($cleApi, $cleSecret);
        return $this->client = Client::create($configuration);
    }

}