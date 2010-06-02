#!/usr/bin/perl -w
package FTYP;
use warnings;
use strict;
use Switch;
use Def;

#
# File type and compatibility
#

#
# It is done.
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    &Def::header($_INDENT_, __PACKAGE__);
    
    my ($brand, $sminor, $minor);
  
    $_SIZE -= &Def::read( $INF, $brand, 4);
    $_SIZE -= &Def::read( $INF, $sminor, 4);

    $minor = unpack("N", $sminor);
    print $_INDENT_, "brand(" . $brand . ")\n";
    print $_INDENT_, "minor(" . $minor . ")\n";

    while ($_SIZE > 0) {
        $_SIZE -= &Def::read( $INF, $brand, 4);
        print $_INDENT_, "brand(" . $brand. ")\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
