#!/usr/bin/perl -w
package IPMC;
use warnings;
use Switch;

sub new ()
{
    my $INF;
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    
    seek($INF, $_SIZE, 1);
}

1;