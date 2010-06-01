#!/usr/bin/perl -w
package Def;
use strict;
use warnings;

$Def::DELIMITER = "  ";

sub header() {
    print $_[0], "+", $_[1], "+", "\n";
}
sub footer() {
    print $_[0], "-", $_[1], "-", "\n";
}

sub read() {
    die "unmatched parameters $#_ \n" if $#_ != 3;
    read $_[0], $_[1], $_[2] or die "read failed\n";
}
