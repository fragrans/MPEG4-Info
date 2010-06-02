#!/usr/bin/perl -w
package STSS;
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
        my ($ssample_number, $sample_number);
        $_SIZE -= &Def::read($INF, $ssample_number, 4);
        $sample_number = unpack("N", $ssample_number);
        print $_INDENT_, "$i: ", $sample_number, "\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
