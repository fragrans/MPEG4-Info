#!/usr/bin/perl -w
package BTRT;
use strict;
use warnings;

sub new()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my ($bufferSizeDB, $maxBitrate, $avgBitrate);
    my ($sbufferSizeDB, $smaxBitrate, $savgBitrate);

    $_SIZE -= read $INF, $sbufferSizeDB, 4 or die "fail to read buffersizeDB.\n";
    $_SIZE -= read $INF, $smaxBitrate, 4 or die "fail to read maxBitrate.\n";
    $_SIZE -= read $INF, $savgBitrate, 4 or die "fail to read avgBitrate.\n";
    
    $bufferSizeDB = unpack("N", $sbufferSizeDB);
    $maxBitrate = unpack("N", $smaxBitrate);
    $avgBitrate = unpack("N", $savgBitrate);

    print $_INDENT_ . "bufferSizeDB: ", $bufferSizeDB, "\n";
    print $_INDENT_ . "maxBitrate: ". $maxBitrate . "\n";
    print $_INDENT_ . "avgBitrate: ". $avgBitrate . "\n";

    die "BTRT size is not zero.\n" if $_SIZE;
}
1;
