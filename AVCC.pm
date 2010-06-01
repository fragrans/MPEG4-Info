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
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my ($hSpacing, $vSpacing);
    my ($shSpacing, $svSpacing);
    $_SIZE -= read $INF, $shSpacing, 4 or die "fail to read horizontal spacing.\n";
    $_SIZE -= read $INF, $svSpacing, 4 or die "fail to read vertical spacing.\n";

    $hSpacing = unpack("N", $shSpacing);
    $vSpacing = unpack("N", $svSpacing);
    print $_INDENT_, "hSpacing: ", $hSpacing, "\n";
    print $_INDENT_, "vSpacing: ", $vSpacing, "\n";

    die "PASP size is not zero" if $_SIZE;
}

1;
