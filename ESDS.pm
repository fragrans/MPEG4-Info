#!/usr/bin/perl -w
package ESDS;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";

    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size

    print $_INDENT_, "I don't know the ESDS content yet.\n";
    seek $INF, $_SIZE, 1;
#    die "size is not zero. \n" if $_SIZE;
}

1;
