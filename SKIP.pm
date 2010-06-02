#!/usr/bin/perl -w
package SKIP;
use warnings;
use strict;

use Switch;
use Box;
use FullBox;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
        
    &Def::header($_INDENT_, __PACKAGE__);
    my (@data, $sdata);
    my $tmp = $_SIZE;
    $_SIZE -= &Def::read($INF, $sdata, $_SIZE);
    @data = unpack("C" x $tmp, $sdata);
    #print $_INDENT_, "data[$tmp]: ", "@data", "\n";
    print $_INDENT_, "not printed. \n";
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
