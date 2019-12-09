<?php

namespace RingCoin\AppBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;

class RingCoinAppBundle extends Bundle
{
    public function getParent(){
        return 'FOSUserBundle';
    }
}
