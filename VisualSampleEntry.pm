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
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    
    my $st = SampleTable->new($INF);
    $st->print($_INDENT_);

    my (@header_reserved, $data_reference_index);
    @header_reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    $_SIZE -= 8; #subtract the sampletable extension size
    
    my ($pre_defined, $reserved, @pre_defined2, $width, $height, $horizresolution, $vertresolution, $reserved2, $frame_count, $compressorname, $depth, $pre_defined3);
    my ($spre_defined, $sreserved, $spre_defined2, $swidth, $sheight, $shorizresolution, $svertresolution, $sreserved2, $sframe_count, $scompressorname, $sdepth, $spre_defined3);
    
    &Def::read($INF, $spre_defined, 2);
    &Def::read($INF, $sreserved, 2);
    &Def::read($INF, $spre_defined2, 12);
    &Def::read($INF, $swidth, 2);
    &Def::read($INF, $sheight, 2);
    &Def::read($INF, $shorizresolution, 4);
    &Def::read($INF, $svertresolution, 4);
    &Def::read($INF, $sreserved2, 4);
    &Def::read($INF, $sframe_count, 2);
    &Def::read($INF, $scompressorname, 32);
    &Def::read($INF, $sdepth, 2);
    &Def::read($INF, $spre_defined3, 2);

    
    $pre_defined = unpack("n", $spre_defined);
    $reserved = unpack("n", $sreserved);
    @pre_defined2 = unpack("N" x 3, $spre_defined2);
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

    $_SIZE -= 70;

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
            
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
    }
    die "size ($_SIZE) is not zero. in VisualSampleEntry.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
