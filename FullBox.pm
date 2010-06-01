#!/usr/bin/perl -w
package FullBox;
use strict;
use warnings;

sub new()
{
    my ($self, $hash, $INF);
    $hash = {};
    $self = $_[0];
    $INF = $_[1];
    
    # This is a Fullbox
    my ($sversion, $sflag, $version, $flag);
    my ($sum);
    $sum = 0;
    $sum += &Def::read($INF, $sversion, 1);
    $sum += &Def::read($INF, $sflag, 3);
    
    $version = unpack("C", $sversion);
    $flag = unpack("B[24]", $sflag);
    $hash->{'version'} = $version;
    $hash->{'flag'} = $flag;
    $hash->{'size'} = $sum;
    bless $hash, $self;
    return $hash;
}
sub get_version() {
    return ($_[0]->{'version'});
}
sub get_flag() {
    return ($_[0]->{'flag'});
}
sub get_size() {
    return ($_[0]->{'size'});
}

sub print() {
    die "Please do give indent.\n" if $#_ != 1;
    print $_[1], "version: ", $_[0]->get_version(), "\n";
    print $_[1], "flag: ", $_[0]->get_flag(), " \n";
    print $_[1], "size: ", $_[0]->get_size(), " \n";    
}

1;
