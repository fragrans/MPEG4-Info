#!/usr/bin/perl -w
package MVHD;
use warnings;
use strict;
use Switch;
use FullBox;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    my $fh = FullBox->new($INF);
    print "version: ", $fh->get_version(), "flag: ", $fh->get_flag(), " \n";
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($creation_time, $modification_time, $timescale, $timeduration);
    my ($screation_time, $smodification_time, $stimescale, $stimeduration);
    
    if ($version == 1) {
        read $INF, $screation_time, 8 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 8 or die "failed to read modification time!\n";
        read $INF, $stimescale, 4 or die "failed to read timescale!\n";
        read $INF, $stimeduration, 8 or die "failed to read timeduration!\n";
        $creation_time = unpack("Q>", $screation_time);
        $modification_time = unpack("Q>", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("Q>", $stimeduration);

        $_SIZE -= 28;
    } elsif ($version == 0) {
        read $INF, $screation_time, 4 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 4 or die "failed to read modification time!\n";
        read $INF, $stimescale, 4 or die "failed to read timescale!\n";
        read $INF, $stimeduration, 4 or die "failed to read timeduration!\n";
        $creation_time = unpack("N", $screation_time);
        $modification_time = unpack("N", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("N", $stimeduration);
        $_SIZE -= 16;
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
    print "\t\t" . "Creation Time: ". gmtime($creation_time + $epoch_diff) . "\n";
    print "\t\t" . "Modification Time: ". gmtime($modification_time + $epoch_diff) . "\n";
    print "\t\t" . "Time scale: ". $timescale . "\n";
    print "\t\t" . "Time duration: ". $timeduration . " ( ". $timeduration/$timescale . ")\n";
    # rate, volume, maxtrix, predefined, etc.
    
    my ($srate, $svolume, $sreserved, $sreserved2, $smatrix, $spre_defined, $snext_track_id);
    my ($rate, $volume, $reserved, @reserved2, @matrix, @pre_defined, $next_track_id);
    
    read $INF, $srate, 4 or die "faile to read rate!\n";
    read $INF, $svolume, 2 or die "failed to read volume!\n";
    read $INF, $sreserved, 2 or die "failed to read reserved!\n";
    read $INF, $sreserved2, 8 or die "failed to read reserved!\n";
    read $INF, $smatrix, 36 or die "failed to read matrix!\n";
    read $INF, $spre_defined, 24 or die "failed to read pre_defined!\n";
    read $INF, $snext_track_id, 4 or die "failed to read next track id!\n";

    $rate = unpack("N", $srate);
    $volume = unpack("n", $svolume);
    $reserved = unpack("n", $sreserved);
    @reserved2 = unpack("NN", $sreserved2);
    @matrix = unpack("NNNNNNNNN", $smatrix);
    @pre_defined = unpack("NNNNNN", $spre_defined);
    $next_track_id = unpack("N", $snext_track_id);
    
    
    printf "\t\t". "rate: 0x%x \n", $rate;
    print "\t\t". "volume: ". $volume . "\n";
    print "\t\t". "reserved: ". $reserved . "\n";
    print "\t\t". "reserved2: ". "@reserved2" . "\n";
    printf "\t\t". "matrix: %x \t%x \t%x\n", $matrix[0], $matrix[1],  $matrix[2];
    printf "\t\t". "matrix: %x \t%x \t%x\n", $matrix[3], $matrix[4],  $matrix[5];
    printf "\t\t". "matrix: %x \t%x \t%x\n", $matrix[6], $matrix[7],  $matrix[8];
    print "\t\t". "pre_defined: ". "@pre_defined" . "\n";
    print "\t\t". "next_track_id: ". $next_track_id . "\n";

    $_SIZE -= 80;
    
    if ($_SIZE != 0) {
        print "I still need to seek $_SIZE to find next token\n";
                         
        seek($INF, $_SIZE, 1);

    }
}

1;
