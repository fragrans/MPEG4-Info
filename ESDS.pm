#!/usr/bin/perl -w
package ESDS;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;

    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size

    print $_INDENT_, "I don't know the ESDS content yet.\n";
    seek $INF, $_SIZE, 1;
#    die "size is not zero. \n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
