#!/usr/bin/perl -w
package FTYP;
use warnings;
use strict;

use Switch;

sub new ()
{
    my ($INF, $counter, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my ($brand, $sminor, $minor);
    
    read( $INF, $brand, 4);
    print $_INDENT_, "brand(" . $brand . ")\n";
    read( $INF, $sminor, 4);
    $minor = unpack("N", $sminor);
    print $_INDENT_, "minor(" . $minor . ")\n";
    $_SIZE -= 8;
    while ($_SIZE > 0) {
        read( $INF, $brand, 4);
        print $_INDENT_, "brand(" . $brand. ")\n";
        $_SIZE -= 4;
    }
    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
}

1;
