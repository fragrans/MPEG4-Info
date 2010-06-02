#!/usr/bin/perl -w
package SMHD;
use strict;
use warnings;
use Switch;
use FullBox;

#
# Sound Media Header Box
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    &Def::header($_INDENT_, __PACKAGE__);    
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    
    my ($sbalance, $sreserved);
    my ($balance, $reserved);
    $_SIZE -= &Def::read($INF, $sbalance, 2);
    $_SIZE -= &Def::read($INF, $sreserved, 2);
    $balance = unpack("n", $sbalance);
    $reserved = unpack("n", $sreserved);
    print $_INDENT_, "balance: ", $balance, "\n";
    print $_INDENT_ ,"reserved: ", $reserved, "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
