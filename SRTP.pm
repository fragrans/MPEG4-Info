#!/usr/bin/perl -w
package SRTP;
use strict;
use warnings;
use Switch;

use SampleTable;
use ESDS;

#
# RTP Hint Sample Entry
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);

    my $DELIMITER = $Def::DELIMITER;

    my $st = SampleTable->new($INF);
    $_SIZE -= $st->get_size();
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    
    my ($shinttrackversion, $shighestcompatibleversion, $smaxpacketsize);
    my ($hinttrackversion, $highestcompatibleversion, $maxpacketsize);
    
    $_SIZE -= &Def::read($INF, $shinttrackversion, 2);
    $_SIZE -= &Def::read($INF, $shighestcompatibleversion, 2);
    $_SIZE -= &Def::read($INF, $smaxpacketsize, 4);
    
    $chinttrackversion = unpack("n", $shinttrackversion);
    $highestcompatibleversion = unpack("n", $shighestcompatibleversion);
    $maxpacketsize = unpack("N", $smaxpacketsize);
    
    print $_INDENT_, "reserved: ", $chinttrackversion, "\n";
    print $_INDENT_, "channelcount: ", $highestcompatibleversion, "\n";
    print $_INDENT_, "samplesize: ", $maxpacketsize, "\n";


    while ($_SIZE > 0) {
        print $_INDENT_, "size: ", $_SIZE, "\n";
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        
        switch($header->get_type()) {
            case "" {

            }
            else {
                die "unknown type in SRTP.\n";
            }
        }
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
