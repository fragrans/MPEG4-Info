#!/usr/bin/perl -w
package MDAT;
use warnings;
use Switch;
use Box;
use FullBox;
sub new ()
{
    my $INF;
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    
    seek($INF, $_SIZE, 1);
}

1;
