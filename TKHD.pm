#!/usr/bin/perl -w
package TKHD;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    my ($creation_time, $modification_time, $track_id, $reserved, $duration);
    my ($screation_time, $smodification_time, $strack_id, $sreserved, $sduration);
    
    if ($version == 1) {
        $_SIZE -= &Def::read($INF, $screation_time, 8);
        $_SIZE -= &Def::read($INF, $smodification_time, 8);
        $_SIZE -= &Def::read($INF, $strack_id, 4);
        $_SIZE -= &Def::read($INF, $sreserved, 4);
        $_SIZE -= &Def::read($INF, $sduration, 8);
        
        $creation_time = unpack("Q>", $screation_time);
        $modification_time = unpack("Q>", $smodification_time);
        $track_id = unpack("N", $track_id);
        $reserved = unpack("N", $sreserved);
        $duration = unpack("Q>", $sduration);
        
    } elsif ($version == 0) {
        $_SIZE -= &Def::read($INF, $screation_time, 4);
        $_SIZE -= &Def::read($INF, $smodification_time, 4);
        $_SIZE -= &Def::read($INF, $strack_id, 4);
        $_SIZE -= &Def::read($INF, $sreserved, 4);
        $_SIZE -= &Def::read($INF, $sduration, 4);
        $creation_time = unpack("N", $screation_time);
        $modification_time = unpack("N", $smodification_time);
        $track_id = unpack("N", $strack_id);
        $reserved = unpack("N", $sreserved);
        $duration = unpack("N", $sduration);
    } else {
        die "weild version found. \n";
    }
    
    # using http://www.epochconverter.com/ to get this difference
    # between two epoch standards
    #
    # Jan. 1. 1070 in UNIX
    # Jan. 1. 1904 in MPEG-4
    #
    #
    my  $epoch_diff = -2082844800;
    print $_INDENT_, "Creation Time: ". gmtime($creation_time + $epoch_diff) . "\n";
    print $_INDENT_, "Modification Time: ". gmtime($modification_time + $epoch_diff) . "\n";
    print $_INDENT_, "Track id: ". $track_id . "\n";
    print $_INDENT_, "Reserved: ". $reserved . "\n";
    print $_INDENT_, "Duration: ". $duration . "\n";
    
    # rate, volume, maxtrix, predefined, etc.
    
    my ($sreserved2, $slayer, $salternate_group, $svolume, $sreserved3, $smatrix, $swidth, $sheight);
    my (@reserved2, $layer, $alternate_group, $volume, $reserved3,@matrix, $width, $height);

    $_SIZE -= &Def::read($INF, $sreserved2, 8);
    $_SIZE -= &Def::read($INF, $slayer, 2);
    $_SIZE -= &Def::read($INF, $salternate_group, 2);
    $_SIZE -= &Def::read($INF, $svolume, 2);
    $_SIZE -= &Def::read($INF, $sreserved3, 2);
    $_SIZE -= &Def::read($INF, $smatrix, 36);
    $_SIZE -= &Def::read($INF, $swidth, 4);
    $_SIZE -= &Def::read($INF, $sheight, 4);
    
    
    @reserved2 = unpack("NN", $sreserved2);
    $layer = unpack("n", $slayer);
    $alternate_group = unpack("n", $salternate_group);
    $volume = unpack("n", $svolume);
    $reserved3 = unpack("n", $sreserved3);
    @matrix = unpack("NNNNNNNNN", $smatrix);
    $width = unpack("N", $swidth);
    $height = unpack("N", $sheight);
    
    
    print $_INDENT_, "reserved2: ". "@reserved2" . "\n";
    print $_INDENT_, "layer: ". $layer . "\n";
    print $_INDENT_, "alternate_group: ". $alternate_group . "\n";
    print $_INDENT_, "volume: ". $volume . "\n";
    printf $_INDENT_ . "matrix: %x \t%x \t%x\n", $matrix[0], $matrix[1],  $matrix[2];
    printf $_INDENT_ . "matrix: %x \t%x \t%x\n", $matrix[3], $matrix[4],  $matrix[5];
    printf $_INDENT_ . "matrix: %x \t%x \t%x\n", $matrix[6], $matrix[7],  $matrix[8];
    print $_INDENT_,  "width: ". $width . "\n";
    print $_INDENT_,  "height: ". $height . "\n";
    
    
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
