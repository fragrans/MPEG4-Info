#!/usr/bin/perl -w
package NULL;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    seek($INF, $_SIZE, 1);
    &Def::header($_INDENT_, __PACKAGE__);
    print $_INDENT_, "This is a box I cann't recognized.\n";
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
