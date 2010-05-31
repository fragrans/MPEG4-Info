#!/usr/bin/perl -w
package AudioSampleEntry;
use strict;
use warnings;
use Switch;

use SampleTable;

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
    
    my $st = SampleTable->new($INF);
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    $_SIZE -= 8; #subtract the sampletable extension size
    
    my (@local_reserved, $channelcount, $samplesize, $pre_defined, $local_reserved2, $samplerate);
    my ($slocal_reserved, $schannelcount, $ssamplesize, $spre_defined, $slocal_reserved2, $ssamplerate);
    
    read $INF, $slocal_reserved, 4 * 2 or die "read reserved failed.\n";
    read $INF, $schannelcount, 2 or die "read channelcount failed.\n";
    read $INF, $ssamplesize, 2 or die "read samplesize failed.\n";
    read $INF, $spre_defined, 2 or die "read pre_defined failed.\n";
    read $INF, $slocal_reserved2, 2 or die "read reserved2 failed.\n";
    read $INF, $ssamplerate, 4 or die "read samplerate failed.\n";
    
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
    print $_INDENT_, "samplerate: ", $samplerate, "\n";
    
    $_SIZE -= 4 * 2 + 2 + 2 + 2 + 2 + 4;
    die "size is not zero in AudioSampleEntry.\n" if $_SIZE;
}

1;
