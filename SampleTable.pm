#!/usr/bin/perl -w
package SampleTable;
use strict;
use warnings;

sub new()
{
    my ($self, $hash, $INF);
    $hash = {};
    $self = $_[0];
    $INF = $_[1];
    
    # This is a SampleTable
    my ($sreserved, $sdata_reference_index, @reserved, $data_reference_index);
    my ($sum);
    $sum = 0;
    $sum += &Def::read($INF, $sreserved, 6);
    $sum += &Def::read($INF, $sdata_reference_index, 2);
    @reserved = unpack("C" x 6, $sreserved);
    $data_reference_index  = unpack("n", $sdata_reference_index);

    $hash->{'reserved'} = "@reserved";
    $hash->{'data_reference_index'} = $data_reference_index;
    $hash->{'size'} = $sum;
    bless $hash, $self;
    return $hash;
}

sub get_reserved() {
    return ($_[0]->{'reserved'});
}

sub get_data_reference_index() {
    return ($_[0]->{'data_reference_index'});
}

sub get_size() {
    return ($_[0]->{'size'});
}
sub print() {
    die "Please do give indent.\n" if $#_ != 1;
    my (@reserved);
    @reserved = $_[0]->get_reserved();
    print $_[1], "reversed: ", "@reserved", "\n";
    print $_[1], "data reference index: ", $_[0]->get_data_reference_index(), " \n";
}
1;
