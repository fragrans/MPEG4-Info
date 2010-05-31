#!/usr/bin/perl -w
package VisualSampleEntry;
use strict;
use warnings;
use Switch;

use SampleTable;
use CLAP;
use PASP;
use NULL;
use BTRT;

#
# visual sample description box
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

    my (@header_reserved, $data_reference_index);
    @header_reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    $_SIZE -= 8; #subtract the sampletable extension size
    
    my ($pre_defined, $reserved, @pre_defined2, $width, $height, $horizresolution, $vertresolution, $reserved2, $frame_count, $compressorname, $depth, $pre_defined3);
    my ($spre_defined, $sreserved, $spre_defined2, $swidth, $sheight, $shorizresolution, $svertresolution, $sreserved2, $sframe_count, $scompressorname, $sdepth, $spre_defined3);
    
    read $INF, $spre_defined, 2 or die "read pre_defined failed.\n";
    read $INF, $sreserved, 2 or die "read reserved failed.\n";
    read $INF, $spre_defined2, 4 * 3 or die "read pre_defined2 failed.\n";
    read $INF, $swidth, 2 or die "read width failed.\n";
    read $INF, $sheight, 2 or die "read height failed.\n";
    read $INF, $shorizresolution, 4 or die "read horizresolution failed.\n";
    read $INF, $svertresolution, 4 or die "read vertresolution failed.\n";
    read $INF, $sreserved2, 4 or die "read reserved2 failed.\n";
    read $INF, $sframe_count, 2 or die "read frame_count failed.\n";
    read $INF, $scompressorname, 4 * 8 or die "read compressorname failed.\n";
    read $INF, $sdepth, 2 or die "read depth failed.\n";
    read $INF, $spre_defined3, 2 or die "read pre_defined3 failed.\n";

    
    $pre_defined = unpack("n", $spre_defined);
    $reserved = unpack("n", $sreserved);
    @pre_defined2 = unpack("NNN", $spre_defined2);
    $width = unpack("n", $swidth);
    $height = unpack("n", $sheight);
    $horizresolution = unpack("N", $shorizresolution);
    $vertresolution = unpack("N", $svertresolution);
    $reserved2 = unpack("N", $sreserved2);
    $frame_count = unpack("n", $sframe_count);
    $compressorname = unpack("C" x 32, $scompressorname);
    $depth = unpack("n", $sdepth);
    $pre_defined3 = unpack("n", $spre_defined3);
    
    print $_INDENT_, "pre_defined: ", $pre_defined, "\n";
    print $_INDENT_, "reserved: ", $reserved, "\n";
    print $_INDENT_, "pre_defined2: ", "@pre_defined2", "\n";
    print $_INDENT_, "width: ", $pre_defined, "\n";
    print $_INDENT_, "height: ", $pre_defined, "\n";
    printf "%s%s0x%x%s", $_INDENT_, "horizresolution: ", $horizresolution, "\n";
    printf "%s%s0x%x%s", $_INDENT_, "vertresolution: ", $vertresolution, "\n";
    print $_INDENT_, "reserved2: ", $reserved2, "\n";
    print $_INDENT_, "frame_count: ", $pre_defined, "\n";
    print $_INDENT_, "compressorname: ", $compressorname, "\n";
    print $_INDENT_, "depth: ", $depth, "\n";
    print $_INDENT_, "pre_defined3: ", $pre_defined3, "\n";

    $_SIZE -= 46;

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
            case "STTS" {
                print $_INDENT_, "++++ STTS ++++\n";
                STTS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- STTS ----\n";
            }
            else {
                die "unknown type in Visual sample entry.\n";
            }
        }
    }
    die "size is not zero.\n" if $_SIZE;
}

1;
