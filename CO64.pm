#!/usr/bin/perl -w
package CO64;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    seek($INF, $_SIZE, 1);
    &Def::header($_INDENT_, __PACKAGE__);
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
