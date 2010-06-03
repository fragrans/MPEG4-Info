#!/usr/bin/perl -w
package FRMA;
use strict;
use warnings;
use Switch;

sub new ()
{
    die "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    my ($INF, $_SIZE, $_INDENT_, $_CODING_NAME);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    $_CODING_NAME= $_[4];
    &Def::header($_INDENT_, __PACKAGE__);
    my $coding_name;
    $_SIZE -= read $INF, $coding_name, 4;
    print $_INDENT_, "size: ", $_SIZE, "\n";
    print $_INDENT_, "coding name: ", $coding_name, "\n";
    print $_INDENT_, "coding name: ", $_CODING_NAME, "\n";
    seek $INF, $_SIZE, 1;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
