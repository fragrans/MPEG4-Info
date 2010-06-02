#!/usr/bin/perl -w
package AVCC;
use strict;
use warnings;
use Switch;

#
# AVCC
#

sub new()
{
    my ($INF, $_SIZE, $_INDENT_);
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;

    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    
    my ($hSpacing, $vSpacing);
    my ($shSpacing, $svSpacing);
    $_SIZE -= &Def::read($INF, $shSpacing, 4);
    $_SIZE -= &Def::read($INF, $svSpacing, 4);

    $hSpacing = unpack("N", $shSpacing);
    $vSpacing = unpack("N", $svSpacing);
    print $_INDENT_, "hSpacing: ", $hSpacing, "\n";
    print $_INDENT_, "vSpacing: ", $vSpacing, "\n";

    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
