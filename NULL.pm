#!/usr/bin/perl -w
package NULL;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];  
    seek($INF, $_SIZE, 1);
}

1;
