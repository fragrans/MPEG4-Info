#!/usr/bin/perl -w
package TKHD;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    my $fh = FullBox->new($INF);
    print "version: ", $fh->get_version(), "flag: ", $fh->get_flag(), " \n";
    $_SIZE -= 4; #subtract the fullheader extension size
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    my ($creation_time, $modification_time, $track_id, $reserved, $duration);
    my ($screation_time, $smodification_time, $strack_id, $sreserved, $sduration);
    
    if ($version == 1) {
        read $INF, $screation_time, 8 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 8 or die "failed to read modification time!\n";
        read $INF, $strack_id, 4 or die "failed to read track id!\n";
        read $INF, $sreserved, 4 or die "failed to read reserved!\n";
        read $INF, $sduration, 8 or die "failed to read duration!\n";
        
        $creation_time = unpack("Q>", $screation_time);
        $modification_time = unpack("Q>", $smodification_time);
        $track_id = unpack("N", $track_id);
        $reserved = unpack("N", $sreserved);
        $duration = unpack("Q>", $sduration);
        
        $_SIZE -= 32;
    } elsif ($version == 0) {
        read $INF, $screation_time, 4 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 4 or die "failed to read modification time!\n";
        read $INF, $strack_id, 4 or die "failed to read track id!\n";
        read $INF, $sreserved, 4 or die "failed to read reserved!\n";
        read $INF, $sduration, 4 or die "failed to read timeduration!\n";
        $creation_time = unpack("N", $screation_time);
        $modification_time = unpack("N", $smodification_time);
        $track_id = unpack("N", $strack_id);
        $reserved = unpack("N", $sreserved);
        $duration = unpack("N", $sduration);
        $_SIZE -= 20;
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
    print "\t\t\t" . "Creation Time: ". gmtime($creation_time + $epoch_diff) . "\n";
    print "\t\t\t" . "Modification Time: ". gmtime($modification_time + $epoch_diff) . "\n";
    print "\t\t\t" . "Track id: ". $track_id . "\n";
    print "\t\t\t" . "Reserved: ". $reserved . "\n";
    print "\t\t\t" . "Duration: ". $duration . "\n";
    
    # rate, volume, maxtrix, predefined, etc.
    
    my ($sreserved2, $slayer, $salternate_group, $svolume, $sreserved3, $smatrix, $swidth, $sheight);
    my (@reserved2, $layer, $alternate_group, $volume, $reserved3,@matrix, $width, $height);

    read $INF, $sreserved2, 8 or die "failed to read reserved2!\n";
    read $INF, $slayer, 2 or die "failed to read layer!\n";
    read $INF, $salternate_group, 2 or die "failed to read alternate_group!\n";
    read $INF, $svolume, 2 or die "failed to read next volume!\n";
    read $INF, $sreserved3, 2 or die "failed to read reserved2!\n";
    read $INF, $smatrix, 36 or die "failed to read matrix!\n";
    read $INF, $swidth, 4 or die "failed to read width!\n";
    read $INF, $sheight, 4 or die "failed to read height!\n";
    
    
    @reserved2 = unpack("NN", $sreserved2);
    $layer = unpack("n", $slayer);
    $alternate_group = unpack("n", $salternate_group);
    $volume = unpack("n", $svolume);
    $reserved3 = unpack("n", $sreserved3);
    @matrix = unpack("NNNNNNNNN", $smatrix);
    $width = unpack("N", $swidth);
    $height = unpack("N", $sheight);
    
    
    print "\t\t\t". "reserved2: ". "@reserved2" . "\n";
    print "\t\t\t". "layer: ". $layer . "\n";
    print "\t\t\t". "alternate_group: ". $alternate_group . "\n";
    print "\t\t\t". "volume: ". $volume . "\n";
    printf "\t\t\t". "matrix: %x \t%x \t%x\n", $matrix[0], $matrix[1],  $matrix[2];
    printf "\t\t\t". "matrix: %x \t%x \t%x\n", $matrix[3], $matrix[4],  $matrix[5];
    printf "\t\t\t". "matrix: %x \t%x \t%x\n", $matrix[6], $matrix[7],  $matrix[8];
    print "\t\t\t". "width: ". $width . "\n";
    print "\t\t\t". "height: ". $height . "\n";
    
    $_SIZE -= 60;
    
    if ($_SIZE != 0) {
        print "I still need to seek $_SIZE to find next token\n";
        seek($INF, $_SIZE, 1);
    }
}

1;
