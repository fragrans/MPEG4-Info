#!/usr/bin/perl -w
package AudioSampleEntry;
use strict;
use warnings;
use Switch;

use SampleTable;
use ESDS;

#
# meta data sample table
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;

    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    my $st = SampleTable->new($INF);
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    $_SIZE -= 8; #subtract the sampletable extension size
    
    my (@local_reserved, $channelcount, $samplesize, $pre_defined, $local_reserved2, $samplerate);
    my ($slocal_reserved, $schannelcount, $ssamplesize, $spre_defined, $slocal_reserved2, $ssamplerate);
    
    $_SIZE -= read $INF, $slocal_reserved, 4 * 2 or die "read reserved failed.\n";
    $_SIZE -= read $INF, $schannelcount, 2 or die "read channelcount failed.\n";
    $_SIZE -= read $INF, $ssamplesize, 2 or die "read samplesize failed.\n";
    $_SIZE -= read $INF, $spre_defined, 2 or die "read pre_defined failed.\n";
    $_SIZE -= read $INF, $slocal_reserved2, 2 or die "read reserved2 failed.\n";
    $_SIZE -= read $INF, $ssamplerate, 4 or die "read samplerate failed.\n";
    
    @local_reserved = unpack("N" x 2, $slocal_reserved);
    $channelcount = unpack("n", $schannelcount);
    $samplesize = unpack("n", $ssamplesize);
    $pre_defined = unpack("n", $spre_defined);
    $local_reserved2 = unpack("n", $slocal_reserved2);
    $samplerate = unpack("N", $ssamplerate);

    
    print $_INDENT_, "reserved: ", "@local_reserved", "\n";
    print $_INDENT_, "channelcount: ", $channelcount, "\n";
    print $_INDENT_, "samplesize: ", $samplesize, "\n";
    print $_INDENT_, "pre_defined: ", $pre_defined, "\n";
    print $_INDENT_, "reserved2: ", $local_reserved2, "\n";
    printf "%s%s0x%x%s", $_INDENT_, "samplerate: ", $samplerate, "\n";
    


    while ($_SIZE > 0) {
        print $_INDENT_, "size: ", $_SIZE, "\n";
        my ($header) = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "clap" {
                CLAP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "pasp" {
                PASP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "avcC" {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "btrt" {
                BTRT->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "stts" {
                STTS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "esds" {
                ESDS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                die "unknown type in Visual sample entry.\n";
            }
        }
    }
    die "size ($_SIZE) is not zero in AudioSampleEntry.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
