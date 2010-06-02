#!/usr/bin/perl -w
package STSZ;
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

    my ($ssample_count, $sample_count);
    my ($ssample_size, $sample_size);
    $_SIZE -= &Def::read($INF, $ssample_size, 4);
    $_SIZE -= &Def::read($INF, $ssample_count, 4);
    $sample_size = unpack("N", $ssample_size);
    $sample_count = unpack("N", $ssample_count);
    
    print $_INDENT_, "there are $sample_count samples.\n";
    print $_INDENT_, "sample size: ", $sample_size, "\n";
    if ($sample_size == 0) {
        my ($i);
        for ($i = 0; $i < $sample_count; $i++) {
            my ($sentry_size, $entry_size);
            $_SIZE -= &Def::read($INF, $sentry_size, 4);
            $entry_size = unpack("N", $sentry_size);
#            print $_INDENT_, "$i: ", $entry_size, "\n";
        }
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
