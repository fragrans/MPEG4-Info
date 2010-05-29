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
    read $INF, $sreserved, 6 or die "failed to read reserved!\n";
    read $INF, $sdata_reference_index, 2 or die "failed to read data reference index!\n";
    @reserved = unpack("CCCCCC", $sreserved);
    $data_reference_index  = unpack("n", $sdata_reference_index);

    $hash->{'reserved'} = @reserved;
    $hash->{'data_reference_index'} = $data_reference_index;
    bless $hash, $self;
    return $hash;
}
sub get_reserved() {
    return ($_[0]->{'reserved'});
}
sub get_data_reference_index() {
    return ($_[0]->{'data_reference_index'});
}
sub print() {
    die "Please do give indent.\n" if $#_ != 1;
    print $_[1], "version: ", "$_[0]->get_reserved()", "flag: ", $_[0]->get_data_reference_index(), " \n";
}
1;
