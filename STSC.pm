#!/usr/bin/perl -w
package STSC;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
     my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();

    my ($sentry_count, $entry_count);
    $_SIZE -= &Def::read($INF, $sentry_count, 4);
    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";
    my ($i);
    for ($i = 0; $i < $entry_count; $i++) {
        my ($sfirst_chunk, $ssamples_per_chunk, $ssample_description_index);
        my ($first_chunk, $samples_per_chunk, $sample_description_index);
        $_SIZE -= &Def::read($INF, $sfirst_chunk, 4);
        $_SIZE -= &Def::read($INF, $ssamples_per_chunk, 4);
        $_SIZE -= &Def::read($INF, $ssample_description_index, 4);
        $first_chunk = unpack("N", $sfirst_chunk);
        $samples_per_chunk = unpack("N", $ssamples_per_chunk);
        $sample_description_index = unpack("N", $ssample_description_index);
#        print $_INDENT_, "first chunk: ", $first_chunk, "\n";
#        print $_INDENT_, "samples per chunk: ", $samples_per_chunk, "\n";
#        print $_INDENT_, "sample description index: ", $sample_description_index, "\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
