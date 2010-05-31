#!/usr/bin/perl -w
package NULL;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    print $_INDENT_, "This is a box I cann't recognized.\n";
    seek($INF, $_SIZE, 1);
}

1;
