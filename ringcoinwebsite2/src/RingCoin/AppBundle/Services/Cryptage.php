<?php
/**
 * Created by IntelliJ IDEA.
 * User: wilson
 * Date: 24/10/17
 * Time: 19:28
 */
namespace RingCoin\AppBundle\Services;

class Cryptage
{
    public function cryptage($min, $max) {
        $range = $max - $min;
        if ($range < 0)
            return $min; // not so random...
        $log = log ( $range, 2 );
        $bytes = ( int ) ($log / 8) + 1; // length in bytes
        $bits = ( int ) $log + 1; // length in bits
        $filter = ( int ) (1 << $bits) - 1; // set all lower bits to 1
        do {
            $rnd = hexdec ( bin2hex ( openssl_random_pseudo_bytes ( $bytes ) ) );
            $rnd = $rnd & $filter; // discard irrelevant bits
        } while ( $rnd >= $range );
        return $min + $rnd;
    }

    public function getCode($length, $maj=true, $min=true) {
        $token = "";
        $code = '';

        if($maj) $code = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        if($min) $code .= "abcdefghijklmnopqrstuvwxyz";
        $code .= "0123456789";

        for($i = 0; $i < $length; $i ++) {
            $token .= $code [self::cryptage ( 0, strlen ( $code ) )];
        }
        return $token;
    }
}