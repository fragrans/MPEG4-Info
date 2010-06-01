#!/usr/bin/perl -w
package FRMA;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE);
    $INF = $_[1];
    $_SIZE = $_[2];
    
    seek($INF, $_SIZE, 1);
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
