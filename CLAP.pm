#!/usr/bin/perl -w
package CLAP;
use strict;
use warnings;
use Switch;

#
# Clean Aperture Box
#

sub new()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    my ($scleanApertureWidthN, $scleanApertureWidthD, $scleanApertureHeightN, $scleanApertureHeightD, $shorizOffN, $shorizOffD, $svertOffN, $svertOffD);
    my ($cleanApertureWidthN, $cleanApertureWidthD, $cleanApertureHeightN, $cleanApertureHeightD, $horizOffN, $horizOffD, $vertOffN, $vertOffD);

    $_SIZE -= read $INF, $scleanApertureWidthN, 4 or die "fail to read cleanApertureWidthN.\n";
    $_SIZE -= read $INF, $scleanApertureWidthD, 4 or die "fail to read cleanApertureWidthD.\n";
    $_SIZE -= read $INF, $scleanApertureHeightN, 4 or die "fail to read cleanApertureHeightN.\n";
    $_SIZE -= read $INF, $scleanApertureHeightD, 4 or die "fail to read cleanApertureHeightD.\n";
    $_SIZE -= read $INF, $shorizOffN, 4 or die "fail to read horizOffN.\n";
    $_SIZE -= read $INF, $shorizOffD, 4 or die "fail to read horizOffD.\n";
    $_SIZE -= read $INF, $svertOffN, 4 or die "fail to read vertOffN.\n";
    $_SIZE -= read $INF, $svertOffD, 4 or die "fail to read vertOffD.\n";    

    $cleanApertureWidthN = unpack("N", $scleanApertureWidthN);
    $cleanApertureWidthN = unpack("N", $scleanApertureWidthD);
    $cleanApertureHeightN = unpack("N", $scleanApertureHeightN);
    $cleanApertureHeightD = unpack("N", $scleanApertureHeightD);
    $horizOffN = unpack("N", $shorizOffN);
    $horizOffD = unpack("N", $shorizOffD);
    $vertOffN = unpack("N", $svertOffN);
    $vertOffD = unpack("N", $svertOffD);

    print $_INDENT_, "cleanApertureWidthN: ", $cleanApertureWidthN, "\n";
    print $_INDENT_, "cleanApertureWidthD: ", $cleanApertureWidthD, "\n";
    print $_INDENT_, "cleanApertureHeightN: ", $cleanApertureHeightN, "\n";
    print $_INDENT_, "cleanApertureHeightD: ", $cleanApertureHeightD, "\n";
    print $_INDENT_, "horizOffN: ", $horizOffN, "\n";
    print $_INDENT_, "horizOffD: ", $horizOffD, "\n";
    print $_INDENT_, "vertOffN: ", $vertOffN, "\n";
    print $_INDENT_, "vertOffD: ", $vertOffD, "\n";

    die "PASP size is not zero" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
