#!/usr/bin/perl -w
package TREF;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    
    seek($INF, $_SIZE, 1);
}

1;
