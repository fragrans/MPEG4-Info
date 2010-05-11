#!/usr/bin/perl -w

package Box;
use strict;
use warnings;
use File::stat;

sub new()
{
    my($self, @array) = @_;
    my($hash) = {};
    $hash->{'size'} = '';
    $hash->{'type'} = '';
    bless $hash, $self;
    return $hash;
}

sub get_size() {
    return ($_[0]->{'size'});
}
sub get_type() {
    return ($_[0]->{'type'});
}

# file descriptor, and counter
sub iter()
{
    my ($size, $type);
    my ($ssize, $stype);
    my ($position, $size);
    my ($bulk) = $_[1];
    
    $INF = \$_[0];
    
    $position = tell INF;

    
    print "position: ", $position, "\n";
    read INF, $ssize, 4 or die "read size failed. $!\n";
    read INF, $stype, 4 or die "read type failed. $!\n";

    $size = unpack("N", $ssize);

    # size is 64 bit?
    if ($size == 1) {
        read INF, $ssize, 8 or die "read long size failed. $!\n";
        $size = unpack("Q>", $ssize);
    } else {
        $size = $counter;
    }
    if ($stype eq "uuid") {
        print "uuid\n";
        read INF, $uuid, 16
        print $uuid;
    }
}
