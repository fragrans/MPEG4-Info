#!/usr/bin/perl -w
package MOOF;
use warnings;
use Switch;
use Box;
use FullBox;
sub new ()
{
    my $INF;
    $INF = $_[1];
    $_SIZE = $_[2];
    
    seek($INF, $_SIZE, 1);
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
