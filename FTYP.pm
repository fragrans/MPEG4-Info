#!/usr/bin/perl -w
package FTYP;
use warnings;
use Switch;
use Box;
use FullBox;
sub new ()
{
    my $INF;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    
    my ($brand, $sminor, $minor);
    
    read( $INF, $brand, 4);
    print "\t", "brand(" . $brand . ")\n";
    read( $INF, $sminor, 4);
    $minor = unpack("N", $sminor);
    print "\t", "minor(" . $minor . ")\n";
    $_SIZE -= 8;
    while ($_SIZE > 0) {
        read( $INF, $brand, 4);
        print "\t", "brand(" . $brand. ")\n";
        $_SIZE -= 4;
    }
    if ($_SIZE != 0) {
        print "I still need to seek $root_session_size to find next token\n";
        seek($INF, $_SIZE, 1);
    }
    
}

1;
