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
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my ($scleanApertureWidthN, $scleanApertureWidthD, $scleanApertureHeightN, $scleanApertureHeightD, $shorizOffN, $shorizOffD, $svertOffN, $svertOffN);
    my ($cleanApertureWidthN, $cleanApertureWidthD, $cleanApertureHeightN, $cleanApertureHeightD, $horizOffN, $horizOffD, $vertOffN, $vertOffN);

    read $INF, $scleanApertureWidthN, 4 or die "fail to read cleanApertureWidthN.\n";
    read $INF, $scleanApertureWidthD, 4 or die "fail to read cleanApertureWidthD.\n";
    read $INF, $scleanApertureHeightN, 4 or die "fail to read cleanApertureHeightN.\n";
    read $INF, $scleanApertureHeightD, 4 or die "fail to read cleanApertureHeightD.\n";
    read $INF, $shorizOffN, 4 or die "fail to read horizOffN.\n";
    read $INF, $shorizOffD, 4 or die "fail to read horizOffD.\n";
    read $INF, $svertOffN, 4 or die "fail to read vertOffN.\n";
    read $INF, $svertOffD, 4 or die "fail to read vertOffD.\n";
  
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

    $_SIZE -= 8;
    die "PASP size is not zero" if $_SIZE;
}

1;