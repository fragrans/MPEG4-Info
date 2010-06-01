#!/usr/bin/perl -w

package Box;
use strict;
use warnings;
use File::stat;
$|=1;
sub new()
{
    my($self) = $_[0];
    my $INF = $_[1];
    my($counter) = $_[2];
    
    my($hash) = {};

    my ($size, $type);
    my ($ssize, $stype);

    my ($position);
    my ($uuid);

    my ($sum);
    $sum = 0;
    $sum += read $INF, $ssize, 4 or die "read size failed. $!\n";
    $sum += read $INF, $stype, 4 or die "read type failed. $!\n";

    $size = unpack("N", $ssize);
    # size is 64 bit?
    if ($size == 1) {
        print "Box size is 1\n";
        $sum += read $INF, $ssize, 8 or die "read long size failed. $!\n";
        $size = unpack("Q>", $ssize);
    } elsif ($size == 0) {
        print "Box size is 0\n";
        $size = $counter;
    }
    
    if ($stype eq "uuid") {
        print "uuid\n";
        $sum += read $INF, $uuid, 16;
        print $uuid;
    }

    $hash->{'size'} = $size;
    $hash->{'type'} = $stype;
    $hash->{'header_size'} = $sum;
    bless $hash, $self;

    return $hash;
}

sub get_body_size() {
    return ($_[0]->{'size'} - $_[0]->{'header_size'});
}

sub get_header_size() {
    return ($_[0]->{'header_size'});
}

sub get_size() {
    return ($_[0]->{'size'});
}

sub get_type() {
    return ($_[0]->{'type'});
}

1;
