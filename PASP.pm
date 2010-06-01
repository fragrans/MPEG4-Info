#!/usr/bin/perl -w
package PASP;
use strict;
use warnings;
use Switch;

#
# Pixel Aspect Ratio Box
#

sub new()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    my ($hSpacing, $vSpacing);
    my ($shSpacing, $svSpacing);
    read $INF, $shSpacing, 4 or die "fail to read horizontal spacing.\n";
    read $INF, $svSpacing, 4 or die "fail to read vertical spacing.\n";
    $hSpacing = unpack("N", $shSpacing);
    $vSpacing = unpack("N", $svSpacing);
    print $_INDENT_, "hSpacing: ", $hSpacing, "\n";
    print $_INDENT_, "vSpacing: ", $vSpacing, "\n";
    $_SIZE -= 8;
    die "PASP size is not zero" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
