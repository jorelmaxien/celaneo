<?php
/**
 * Created by PhpStorm.
 * User: wilson
 * Date: 27/10/17
 * Time: 15:27
 */

namespace RingCoin\AppBundle\Events;


final class RingCoinEvents
{
    const NEW_TRANSACTION = 'ring_coin_app.new_transaction';
    const NEW_LOGIN = 'ring_coin_app.new_login';
    const SEND_MAIL = 'ring_coin_app.send_mail';
    const SEND_SIMPLE_MAIL = 'ring_coin_app.send_simple_mail';
    const EMAIL_ACTIVATION = 'ring_coin_app.email_activation';
}