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
    my ($INF, $_SIZE, $_INDENT_, $_CODING_NAME);

    die "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;

    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    $_CODING_NAME = $_[4];
    
    &Def::header($_INDENT_, __PACKAGE__);

    my $DELIMITER = $Def::DELIMITER;

    my $st = SampleTable->new($INF);
    $_SIZE -= $st->get_size();
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    
    my (@local_reserved, $channelcount, $samplesize, $pre_defined, $local_reserved2, $samplerate);
    my ($slocal_reserved, $schannelcount, $ssamplesize, $spre_defined, $slocal_reserved2, $ssamplerate);
    
    $_SIZE -= &Def::read($INF, $slocal_reserved, 8);
    $_SIZE -= &Def::read($INF, $schannelcount, 2);
    $_SIZE -= &Def::read($INF, $ssamplesize, 2);
    $_SIZE -= &Def::read($INF, $spre_defined, 2);
    $_SIZE -= &Def::read($INF, $slocal_reserved2, 2);
    $_SIZE -= &Def::read($INF, $ssamplerate, 4);
    
    @local_reserved = unpack("N" x 2, $slocal_reserved);
    $channelcount = unpack("n", $schannelcount);
    $samplesize = unpack("n", $ssamplesize);
    $pre_defined = unpack("n", $spre_defined);
    $local_reserved2 = unpack("n", $slocal_reserved2);
    $samplerate = unpack("N", $ssamplerate);

    
    print $_INDENT_, "Coding Name: ", $_CODING_NAME, "\n";
    print $_INDENT_, "reserved: ", "@local_reserved", "\n";
    print $_INDENT_, "channelcount: ", $channelcount, "\n";
    print $_INDENT_, "samplesize: ", $samplesize, "\n";
    print $_INDENT_, "pre_defined: ", $pre_defined, "\n";
    print $_INDENT_, "reserved2: ", $local_reserved2, "\n";
    printf "%s%s0x%x%s", $_INDENT_, "samplerate: ", $samplerate, "\n";
    

    while ($_SIZE > 0) {
        print $_INDENT_, "size: ", $_SIZE, "\n";
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        
        switch($header->get_type()) {
            case "esds" {
                ESDS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                die "unknown type in Visual sample entry.\n";
            }
        }
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
