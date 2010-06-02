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
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);

    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    
    my $st = SampleTable->new($INF);
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    my (@data, $sdata);
    my $tmp = $_SIZE;
    $_SIZE -= &Def::read($INF, $sdata, $_SIZE);
    @data = unpack("C" x $tmp, $sdata);
    print $_INDENT_, "data[$tmp]: ", "@data", "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
