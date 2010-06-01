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
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";
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
        my ($header) = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "clap" {
                print $_INDENT_, "++++ CLAP ++++\n";
                CLAP->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- CLAP ----\n";
            }
            case "pasp" {
                print $_INDENT_, "++++ PASP ++++\n";
                PASP->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- PASP ----\n";
            }
            case "avcC" {
                print $_INDENT_, "++++ AVCC ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- AVCC ----\n";
            }
            case "btrt" {
                print $_INDENT_, "++++ BTRT ++++\n";
                BTRT->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- BTRT ----\n";
            }
            case "stts" {
                print $_INDENT_, "++++ STTS ++++\n";
                STTS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- STTS ----\n";
            }
            case "esds" {
                print $_INDENT_, "++++ ESDS ++++\n";
                ESDS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- ESDS ----\n";
            }
            else {
                die "unknown type in Visual sample entry.\n";
            }
        }
    }
    die "size ($_SIZE) is not zero in AudioSampleEntry.\n" if $_SIZE;
}

1;
