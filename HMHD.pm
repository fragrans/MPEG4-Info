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
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    my ($smaxPDUsize, $savgPDUsize, $smaxbitrate, $savgbitrate, $sreserved);   
    my ($maxPDUsize, $avgPDUsize, $maxbitrate, $avgbitrate, $reserved);

    &Def::read($INF, $smaxPDUsize, 2);
    &Def::read($INF, $savgPDUsize, 2);
    &Def::read($INF, $smaxbitrate, 4);
    &Def::read($INF, $savgbitrate, 4);
    &Def::read($INF, $sreserved, 4);
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
    $_SIZE -= (4*3 + 2*2);
    die "HDHD size is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}


1;
