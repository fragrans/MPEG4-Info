#!/usr/bin/perl -w
package BTRT;
use strict;
use warnings;

sub new()
{
    my ($INF, $_SIZE, $_INDENT_);
    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
    
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    &Def::header($_INDENT_, __PACKAGE__);
    
    my ($bufferSizeDB, $maxBitrate, $avgBitrate);
    my ($sbufferSizeDB, $smaxBitrate, $savgBitrate);

    $_SIZE -= &Def::read($INF, $sbufferSizeDB, 4);
    $_SIZE -= &Def::read($INF, $smaxBitrate, 4);
    $_SIZE -= &Def::read($INF, $savgBitrate, 4);
    
    $bufferSizeDB = unpack("N", $sbufferSizeDB);
    $maxBitrate = unpack("N", $smaxBitrate);
    $avgBitrate = unpack("N", $savgBitrate);

    print $_INDENT_ . "bufferSizeDB: ", $bufferSizeDB, "\n";
    print $_INDENT_ . "maxBitrate: ". $maxBitrate . "\n";
    print $_INDENT_ . "avgBitrate: ". $avgBitrate . "\n";

    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}
1;
