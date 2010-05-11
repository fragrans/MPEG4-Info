#!/usr/bin/perl -w
package MOOF;
use warnings;
use Switch;
use Box;
use FullBox;
sub new ()
{
    INF = $@_[1];
    $_SIZE = $_[2];
    $counter = @_[3];
    
    seek(INF, $_SIZE, 1);
}
