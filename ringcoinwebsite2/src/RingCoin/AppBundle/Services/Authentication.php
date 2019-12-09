<?php

namespace RingCoin\AppBundle\Services;

use Coinbase\Wallet\Client;
use Coinbase\Wallet\Configuration;
use Coinbase\Wallet\Enum\Param;
use Coinbase\Wallet\Resource\Transaction;
use FOS\UserBundle\Doctrine\UserManager;
use JMS\Serializer\SerializerBuilder;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Encoder\EncoderFactory;
use Symfony\Component\Yaml\Dumper;

/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 26/10/17
 * Time: 17:48
 */

class Authentication
{
    private $user_manager;

    private $factory;

    private $client;


    public function __construct(EncoderFactory $factory, UserManager $user_manager)
    {
        $this->factory = $factory;
        $this->user_manager = $user_manager;
    }

    public function authenticateCoinbaseApi($cleApi, $cleSecret){
        $configuration = Configuration::apiKey($cleApi, $cleSecret);
        return $this->client = Client::create($configuration);
    }

    public function getCoinBaseTransactionsUser(String $wallet, String $addressUser){

        if ($wallet=='BTC'){
          $account = $this->client->getPrimaryAccount();
        }elseif ($wallet=='ETH'){
            $account = $this->client->getAccounts()[1];
        }else{
            $account = $this->client->getAccounts()[0];
        }

        $this->client->enableActiveRecord();
        $adresses = $this->client->getAccountAddresses($account, [Param::FETCH_ALL=>true]);
        $transactionsUser=[];

        $adresses = $this->client->getAccountAddresses($account);
        $x = new Client();
        $r = new Transaction();
        


        foreach ($adresses as $adress){
            if ($adress->getAddress()==$addressUser){

                foreach ($this->client->getAddressTransactions($adress) as $data){
                    $transactionsUser[] = $data->getRawData();
                }
                break;
            }
        }

        $serializer = SerializerBuilder::create()->build();
        $transactionsUser = $serializer->serialize($transactionsUser, 'json');
        $transactionsUser = json_decode($transactionsUser, true);

        return $transactionsUser;
    }

    public function writeParameter(array $data){
        $dumper = new Dumper();
        $ymlDumper = array('parameters'=> array(
            'prixRC'=>$data['prixRC']
        ));

        $yaml = $dumper->dump($ymlDumper);
        file_put_contents($data['fileParameter'], $yaml);
    }

    public function authenticate($username, $password)
    {
        $user = $this->user_manager->findUserByUsername($username);

        if ($user==null){
            return new JsonResponse('aucun user');
        }else{
            $encoder = $this->factory->getEncoder($user);
            $rep = $encoder->isPasswordValid($user->getPassword(),$password,$user->getSalt());
            if ($rep){
                $serializer = SerializerBuilder::create()->build();
                $jsonContent = $serializer->serialize($user, 'json');
                return new  Response($jsonContent, Response::HTTP_OK, array('Content-Type' => 'application/json'));
            }else{
                return new JsonResponse('false');
            }
        }
    }

}