#!/usr/bin/perl -w
package PASP;
use strict;
use warnings;
use Switch;

#
# Pixel Aspect Ratio Box
#

sub new()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";
    
    seek($INF, $_SIZE, 1);
}

1;
