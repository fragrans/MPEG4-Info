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
    read $INF, $sversion, 1 or die "failed to read version!\n";
    read $INF, $sflag, 3 or die "failed to read flag!\n";
    $version = unpack("C", $sversion);
    $flag = unpack("B[24]", $sflag);
#    print "\t\t" . "version: " . $version, "||", $flag . "\n";
    $hash->{'version'} = $version;
    $hash->{'flag'} = $flag;
    bless $hash, $self;
    return $hash;
}
sub get_version() {
    return ($_[0]->{'version'});
}
sub get_flag() {
    return ($_[0]->{'flag'});
}
sub print() {
    die "Please do give indent.\n" if $#_ != 1;
    print $_[1], "version: ", $_[0]->get_version(), "flag: ", $_[0]->get_flag(), " \n";
}
1;
