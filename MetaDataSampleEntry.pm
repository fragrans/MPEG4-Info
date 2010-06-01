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
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
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
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
