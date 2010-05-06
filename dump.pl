#!/usr/bin/perl -w
use warnings;
use File::stat;
use Switch;
print "MPEG4 information extractor by Li. Tuvok\n";
my $file = "640-480.wmv.MP4";
open INF, $file
    or die "\nCan't open $file for reading: $!\n";
binmode INF;
my $ssize;
my $stype;
my $size;
my $counter;
my $uuid;
my $session;
my $header_size;

$counter = stat($file)->size;
print "file size: ".$counter;
print "\n";
while (
    read (INF, $ssize, 4) 
    and
    read (INF, $stype, 4)) {
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
        $size = $counter;
    }
    if ($stype eq "uuid") {
        print "uuid\n";
        read (INF, $uuid, 16);
        $header_size += 16;
    }
    $session = $size - $header_size;

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
            $session -= 8;
            while ($session > 0) {
                read( INF, $brand, 4);
                print "brand(" . $brand. ")\n";
                $session -= 4;
            }
            if ($session != 0) {
                print "I still need to seek $session to find next token\n";
            }
        }
        # pdin
        case "pdin" {
            print $stype. "(" . $size . ")";
            print "\n";
            print "session size: ". $session. "\n";
            seek (INF, $size - $header_size, 1);
        }
        # moov
        case "moov" {
            print $stype. "(" . $size . ")";
            print "\n";
            print "session size: ". $session . "\n";
            my ($ssize, $size, $header_size);
            while ($session > 0) {
                if (read (INF, $ssize, 4) &&  read (INF, $stype, 4)) {
                    print $ssize;
                    print "\n";
                    print $stype;
                    print "\n";
                    $size = unpack("N", $ssize);
                    print "size: ". $size . "\n";
                } else {
                    die "ERRORRRR\n";
                }
                # size is 64bit ?
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
                my $moov_session = $session - $header_size;
                switch ($stype) {
                    case "" { }
                    else {}
                }
                print "moov session : ". $moov_session;
                
                print "\n";
                seek(INF, $moov_session, 1);
                $session -= $size;
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
