#!/usr/bin/perl -w
use warnings;
use File::stat;
use Switch;

$|++;
print "MPEG4 information extractor by Li. Tuvok\n";
my $file = "640-480.wmv.MP4";
open INF, $file
    or die "\nCan't open $file for reading: $!\n";
binmode INF;
my $ssize;
my $stype;
my $size;
my $counter;
my $header_size;
$counter = stat($file)->size;
print "file size: ".$counter;
print "\n";
while ($counter > 0) {
    print "--------------------------\n";
    print "counter: " . $counter . "\n";
    read (INF, $ssize, 4); 
    read (INF, $stype, 4);
    
    $size = unpack("N", $ssize);
    # size is 64bit ?
    my ($root_session_size);
    $header_size = 8;
    
    if ($size == 1) {
        print "size == 1\n";
        
        read (INF, $ssize, 8);
        $size = unpack("Q>", $ssize);
        $header_size += 8;
    } elsif ($size == 0) {
        print "size == 0\n";
        $size = $counter;
    }
    if ($stype eq "uuid") {
        print "uuid\n";
        read (INF, $uuid, 16);
        $header_size += 16;
    }
    $root_session_size = $size - $header_size;
    $counter -= $size;
    
    switch ($stype) {
        # ftyp
        case "ftyp" {
            print $stype. "(" . $size . ")\n";
            my ($brand, $sminor, $minor);
            read( INF, $brand, 4);
            print "brand(" . $brand . ")\n";
            read( INF, $sminor, 4);
            $minor = unpack("N", $sminor);
            print "minor(" . $minor . ")\n";
            $root_session_size -= 8;
            while ($root_session_size > 0) {
                read( INF, $brand, 4);
                print "brand(" . $brand. ")\n";
                $root_session_size -= 4;
            }
            if ($root_session_size != 0) {
                print "I still need to seek $root_session_size to find next token\n";
            }
        }
        # pdin
        case "pdin" {
            print $stype. "(" . $size . ")";
            print "\n";
            print "session size: ". $root_session_size. "\n";
            seek (INF, $size - $header_size, 1);
        }
        # moov
        case "moov" {
            print $stype. "(" . $size . ")\n";
           # print "session size: ". $root_session_size . "\n";
           
            
            while ($root_session_size > 0) {
                my ($moov_session_size);
                read INF, $ssize, 4 or die "read size failed. $!\n";
                read INF, $stype, 4 or die "read type failed. $!\n";
                
                $size = unpack("N", $ssize);
                
                # size is 64bit ?
                $header_size = 8;
                if ($size == 1) {
                    print "size == 1\n";
                    read (INF, $ssize, 8);
                    $size = unpack("Q>", $ssize);
                    $header_size += 8;
                } elsif ($size == 0) {
                    print "size == 0\n";
                    $size = 0;
                }
                if ($stype eq "uuid") {
                    print "uuid\n";
                    read (INF, $uuid, 16);
                    $header_size += 16;
                }
                
                $root_session_size -= $size;
                $moov_session_size = $size - $header_size;
                switch ($stype) {
                    case "mvhd" {
                        print "\t" . $stype. "(" . $size . ")";
                        print "\n";
                        # This is a Fullbox
                        my ($sversion, $sflag, $version, $flag);
                        read INF, $sversion, 1 or die "failed to read version!\n";
                        read INF, $sflag, 3 or die "failed to read flag!\n";
                        $version = unpack("C", $sversion);
                        $flag = unpack("B[24]", $sflag);
                        print "\t\t" . "version: " . $version, "||", $flag . "\n";
                        $moov_session_size -= 4;
                        my ($creation_time, $modification_time, $timescale, $timeduration);
                        my ($screation_time, $smodification_time, $stimescale, $stimeduration);
                        
                        if ($version == 1) {
                            read INF, $screation_time, 8 or die "failed to read creation time!\n";
                            read INF, $smodification_time, 8 or die "failed to read modification time!\n";
                            read INF, $stimescale, 4 or die "failed to read timescale!\n";
                            read INF, $stimeduration, 8 or die "failed to read timeduration!\n";
                            $creation_time = unpack("Q>", $screation_time);
                            $modification_time = unpack("Q>", $smodification_time);
                            $timescale = unpack("N", $stimescale);
                            $timeduration = unpack("Q>", $stimeduration);

                            $moov_session_size -= 28;
                        } elsif ($version == 0) {
                            read INF, $screation_time, 4 or die "failed to read creation time!\n";
                            read INF, $smodification_time, 4 or die "failed to read modification time!\n";
                            read INF, $stimescale, 4 or die "failed to read timescale!\n";
                            read INF, $stimeduration, 4 or die "failed to read timeduration!\n";
                            $creation_time = unpack("N", $screation_time);
                            $modification_time = unpack("N", $smodification_time);
                            $timescale = unpack("N", $stimescale);
                            $timeduration = unpack("N", $stimeduration);
                            $moov_session_size -= 16;
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
                        read INF, $srate, 4 or die "faile to read rate!\n";
                        read INF, $svolume, 2 or die "failed to read volume!\n";
                        read INF, $sreserved, 2 or die "failed to read reserved!\n";
                        read INF, $sreserved2, 8 or die "failed to read reserved!\n";
                        read INF, $smatrix, 36 or die "failed to read matrix!\n";
                        read INF, $spre_defined, 24 or die "failed to read pre_defined!\n";
                        read INF, $snext_track_id, 4 or die "failed to read next track id!\n";
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

                        $moov_session_size -= 80;
                        
                        if ($moov_session_size != 0) {
                            print "I still need to seek $moov_session_size to find next token\n";
                        }
                        seek(INF, $moov_session_size, 1);                     
                    }
                    case "trak" {
                        print "\t" . $stype. "(" . $size . ")";
                        print "\n";

                        
                        while ($moov_session_size > 0) {
                            my ($trak_session_size);                            
                            read INF, $ssize, 4 or die "read size failed. $!\n";
                            read INF, $stype, 4 or die "read type failed. $!\n";
                
                            $size = unpack("N", $ssize);
                            
                            # size is 64bit ?
                            $header_size = 8;
                            if ($size == 1) {
                                print "size == 1\n";
                                read (INF, $ssize, 8);
                                $size = unpack("Q>", $ssize);
                                $header_size += 8;
                            } elsif ($size == 0) {
                                print "size == 0\n";
                                $size = 0;
                            }
                            if ($stype eq "uuid") {
                                print "uuid\n";
                                read (INF, $uuid, 16);
                                $header_size += 16;
                            }
                            
                            $trak_session_size = $size - $header_size;
                            $moov_session_size -= $size;
                            switch($stype) {
                                case "tkhd" {
                                    print "\t\t" . $stype. "(" . $size . ")\n";
                                    # This is a Fullbox
                                    my ($sversion, $sflag, $version, $flag);
                                    read INF, $sversion, 1 or die "failed to read version!\n";
                                    read INF, $sflag, 3 or die "failed to read flag!\n";
                                    $version = unpack("C", $sversion);
                                    $flag = unpack("B[24]", $sflag);
                                    print "\t\t" . "version: " . $version, "||", $flag . "\n";
                                    $trak_session_size -= 4;
                                    my ($creation_time, $modification_time, $track_id, $reserved, $duration);
                                    my ($screation_time, $smodification_time, $strack_id, $sreserved, $sduration);
                                    
                                    if ($version == 1) {
                                        read INF, $screation_time, 8 or die "failed to read creation time!\n";
                                        read INF, $smodification_time, 8 or die "failed to read modification time!\n";
                                        read INF, $strack_id, 4 or die "failed to read track id!\n";
                                        read INF, $sreserved, 4 or die "failed to read reserved!\n";
                                        read INF, $sduration, 8 or die "failed to read duration!\n";
                                        
                                        $creation_time = unpack("Q>", $screation_time);
                                        $modification_time = unpack("Q>", $smodification_time);
                                        $track_id = unpack("N", $track_id);
                                        $reserved = unpack("N", $sreserved);
                                        $duration = unpack("Q>", $sduration);
                                        
                                        $trak_session_size -= 32;
                                    } elsif ($version == 0) {
                                        read INF, $screation_time, 4 or die "failed to read creation time!\n";
                                        read INF, $smodification_time, 4 or die "failed to read modification time!\n";
                                        read INF, $strack_id, 4 or die "failed to read track id!\n";
                                        read INF, $sreserved, 4 or die "failed to read reserved!\n";
                                        read INF, $sduration, 4 or die "failed to read timeduration!\n";
                                        $creation_time = unpack("N", $screation_time);
                                        $modification_time = unpack("N", $smodification_time);
                                        $track_id = unpack("N", $strack_id);
                                        $reserved = unpack("N", $sreserved);
                                        $duration = unpack("N", $sduration);
                                        $trak_session_size -= 20;
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

                                    read INF, $sreserved2, 8 or die "failed to read reserved2!\n";
                                    read INF, $slayer, 2 or die "failed to read layer!\n";
                                    read INF, $salternate_group, 2 or die "failed to read alternate_group!\n";
                                    read INF, $svolume, 2 or die "failed to read next volume!\n";
                                    read INF, $sreserved3, 2 or die "failed to read reserved2!\n";
                                    read INF, $smatrix, 36 or die "failed to read matrix!\n";
                                    read INF, $swidth, 4 or die "failed to read width!\n";
                                    read INF, $sheight, 4 or die "failed to read height!\n";
                                    
                                    
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
                                    
                                    $trak_session_size -= 60;
                                    
                                    if ($trak_session_size != 0) {
                                        print "I still need to seek $trak_session_size to find next token\n";
                                    }
                                    seek(INF, $trak_session_size, 1);                   
                                    
                                } # end of tkhd
                                else {
                                    print "\t\t" . $stype. "(" . $size . ")\n";
                                    if ($trak_session_size != 0) {
                                        # print "I still need to seek $trak_session_size to find next token\n";
                                    }
                                    seek(INF, $trak_session_size, 1);
                                }
                            }# end of trak switch, box inside trak
                            
                            
                        } # end of trak loop
                    } # end of trak
                    else {
                        print "\t" . $stype. "(" . $size . ")";
                        print "\n";
                        if ($moov_session_size != 0) {
                            #print "I still need to seek $moov_session_size to find next token\n";
                        }
                        seek(INF, $moov_session_size, 1);
                    }
                }    
            }
            if ($root_session_size != 0) {
                print "I still need to seek $root_session_size to find next token\n";
            }
        }
        case "free" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "mdat" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        
        case "moof" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "mfra" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "skip" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "meta" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "meco" {
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
        case "uuid" {
            print $stype. "(" . $size . ")";
            print "\n";
            switch ($uuid) {
                case "" { }
                else { }
            }
            seek (INF, $size - $header_size, 1);
        }
        else {
            print "default\n";
            print $stype. "(" . $size . ")";
            print "\n";
            seek (INF, $size - $header_size, 1);
        }
    }
    if ($size <= 1) {
        print ("size <= 1\n exiting!\n");
	exit (0);
    }

    
};

die "\n Problem readling: $!\n" if $!;

close INF
    or die "\nCan't close $file: $!\n";
