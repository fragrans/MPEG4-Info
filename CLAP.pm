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
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    &Def::header($_INDENT_, __PACKAGE__);
    my ($scleanApertureWidthN, $scleanApertureWidthD, $scleanApertureHeightN, $scleanApertureHeightD, $shorizOffN, $shorizOffD, $svertOffN, $svertOffD);
    my ($cleanApertureWidthN, $cleanApertureWidthD, $cleanApertureHeightN, $cleanApertureHeightD, $horizOffN, $horizOffD, $vertOffN, $vertOffD);

    $_SIZE -= &Def::read($INF, $scleanApertureWidthN, 4);
    $_SIZE -= &Def::read($INF, $scleanApertureWidthD, 4);
    $_SIZE -= &Def::read($INF, $scleanApertureHeightN, 4);
    $_SIZE -= &Def::read($INF, $scleanApertureHeightD, 4);
    $_SIZE -= &Def::read($INF, $shorizOffN, 4);
    $_SIZE -= &Def::read($INF, $shorizOffD, 4);
    $_SIZE -= &Def::read($INF, $svertOffN, 4);
    $_SIZE -= &Def::read($INF, $svertOffD, 4);

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

    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
