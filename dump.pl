#!/usr/bin/perl -w
use warnings;
use File::stat;

print "MPEG4 information extractor by Li. Tuvok\n";
my $file = "../y252-all.wmv.mp4";
open INF, $file
    or die "\nCan't open $file for reading: $!\n";
binmode INF;
my $ssize;
my $stype;
my $size;
my $counter;
$counter = stat($file)->size;
print "file size: ".$counter;
print "\n";
while (
    read (INF, $ssize, 4) 
    and
    read (INF, $stype, 4)) {
    $size = unpack("N", $ssize);
    
    print "\nsize = ".$size;
    print "\ntype = ".$stype;
    print "\n";
    
    if ($size <= 1) {
	exit (0);
    }

    seek (INF, $size - 4, 1)
};
die "\n Problem readling: $!\n" if $!;

close INF
or die "\nCan't close $file: $!\n";
