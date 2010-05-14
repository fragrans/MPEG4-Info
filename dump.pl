#!/usr/bin/perl -w
use warnings;
use File::stat;
use Switch;
use Container;
$|++;

print "MPEG4 information extractor by Li. Tuvok\n";
my $file = "640-480.wmv.MP4";

if (($#ARGV+1) == 1) {
    $file = $ARGV[0];
}
print "file name : $file\n";
my $INF;

open $INF, $file
    or die "\nCan't open $file for reading: $!\n";

binmode $INF;

my $ssize;
my $stype;
my $size;
my $counter;
my $header_size;

$counter = stat($file)->size;
print "file size: ".$counter;
print "\n";

Container->new(*$INF{IO}, $counter, $counter, "");

close $INF
    or die "\nCan't close $file: $!\n";



