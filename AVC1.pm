#!/usr/bin/perl -w
package AVC1;
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

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
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
    $_SIZE -= $st->get_size(); #subtract the sampletable extension size
    
    my ($pre_defined, $reserved, @pre_defined2, $width, $height, $horizresolution, $vertresolution, $reserved2, $frame_count, $compressorname, $depth, $pre_defined3);
    my ($spre_defined, $sreserved, $spre_defined2, $swidth, $sheight, $shorizresolution, $svertresolution, $sreserved2, $sframe_count, $scompressorname, $sdepth, $spre_defined3);
    
    $_SIZE -= read $INF, $spre_defined, 2 or die "read pre_defined failed.\n";
    $_SIZE -= read $INF, $sreserved, 2 or die "read reserved failed.\n";
    $_SIZE -= read $INF, $spre_defined2, 4 * 3 or die "read pre_defined2 failed.\n";
    $_SIZE -= read $INF, $swidth, 2 or die "read width failed.\n";
    $_SIZE -= read $INF, $sheight, 2 or die "read height failed.\n";
    $_SIZE -= read $INF, $shorizresolution, 4 or die "read horizresolution failed.\n";
    $_SIZE -= read $INF, $svertresolution, 4 or die "read vertresolution failed.\n";
    $_SIZE -= read $INF, $sreserved2, 4 or die "read reserved2 failed.\n";
    $_SIZE -= read $INF, $sframe_count, 2 or die "read frame_count failed.\n";
    $_SIZE -= read $INF, $scompressorname, 32 or die "read compressorname failed.\n";
    $_SIZE -= read $INF, $sdepth, 2 or die "read depth failed.\n";
    $_SIZE -= read $INF, $spre_defined3, 2 or die "read pre_defined3 failed.\n";
    
    
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

    while ($_SIZE > 0) {
        print $_INDENT_, "size: ", $_SIZE, "\n";
        my ($header) = Box->new($INF);
        $header->print($_INDENT_);
        $_SIZE -= $header->get_size();
        
        switch($header->get_type()) {        
            case "esds" {
                ESDS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
             case "avcC" {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            
            case "btrt" {
                BTRT->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
#                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
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
