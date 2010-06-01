#!/usr/bin/perl -w
package FTYP;
use warnings;
use strict;

use Switch;

#
# File type and compatibility
#

#
# It is done.
#
sub new ()
{
    my ($INF, $counter, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my ($brand, $sminor, $minor);
  
    $_SIZE -= read( $INF, $brand, 4) or die "failed to read brand.\n";
    $_SIZE -= read( $INF, $sminor, 4) or die "failed to read minor.\n";

    $minor = unpack("N", $sminor);
    print $_INDENT_, "brand(" . $brand . ")\n";
    print $_INDENT_, "minor(" . $minor . ")\n";

    while ($_SIZE > 0) {
        $_SIZE -= read( $INF, $brand, 4);
        print $_INDENT_, "brand(" . $brand. ")\n";
    }

    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
}

1;
