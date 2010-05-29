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
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($sbalance, $sreserved);
    my ($balance, $reserved);
    read $INF, $sbalance, 2 or die "failed to read balance.\n";
    read $INF, $sreserved, 2 or die "failed to read reserved.\n";
    $balance = unpack("n", $sbalance);
    $reserved = unpack("n", $sreserved);
    print $_INDENT_, "balance: ", $balance, "\n";
    print $_INDENT_ ,"reserved: ", $reserved, "\n";
    $_SIZE -= 4;
    die $_INDENT_ . "SMHD size is not zero.\n" if $_SIZE;
}

1;
