#!/usr/bin/perl -w
package HMHD;
use strict;
use warnings;
use Switch;

#
# The hint media header contains general information, 
# independent of the protocol, for hint tracks. 
# (A PDU is a Protocol Data Unit.)
#
sub new ()
{
    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
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
    my ($smaxPDUsize, $savgPDUsize, $smaxbitrate, $savgbitrate, $sreserved);   
    my ($maxPDUsize, $avgPDUsize, $maxbitrate, $avgbitrate, $reserved);

    $_SIZE -= &Def::read($INF, $smaxPDUsize, 2);
    $_SIZE -= &Def::read($INF, $savgPDUsize, 2);
    $_SIZE -= &Def::read($INF, $smaxbitrate, 4);
    $_SIZE -= &Def::read($INF, $savgbitrate, 4);
    $_SIZE -= &Def::read($INF, $sreserved, 4);
    $maxPDUsize = unpack("n", $smaxPDUsize);
    $avgPDUsize = unpack("n", $savgPDUsize);
    $maxbitrate = unpack("N", $smaxbitrate);
    $avgbitrate = unpack("N", $savgbitrate);
    $reserved = unpack("N", $sreserved);

    print $_INDENT_, "maxPDUsize: ", $maxPDUsize;
    print $_INDENT_, "avgPDUsize: ", $avgPDUsize;
    print $_INDENT_, "maxbitrate: ", $maxbitrate;
    print $_INDENT_, "avgbitrate: ", $avgbitrate;
    print $_INDENT_, "reserved: ", $reserved;
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}


1;
