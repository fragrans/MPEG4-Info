#!/usr/bin/perl -w
package MetaDataSampleEntry;
use strict;
use warnings;
use Switch;

use SampleTable;

#
# meta data sample table
#
sub new ()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my $st = SampleTable->new($INF);
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    $_SIZE -= 8; #subtract the sampletable extension size
    my (@data, $sdata);
    read $INF, $sdata, $_SIZE or die "read data failed.\n";
    @data = unpack("C" x $_SIZE, $sdata);
    print $_INDENT_, "data: ", "@data", "\n";
    $_SIZE -= $_SIZE;
    die "size is not zero.\n" if $_SIZE;
}

1;
