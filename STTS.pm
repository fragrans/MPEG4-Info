#!/usr/bin/perl -w
package STTS;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
    
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;

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
        my ($ssample_count, $ssample_delta);
        my ($sample_count, $sample_delta);
        
        $_SIZE -= &Def::read($INF, $ssample_count, 4);
        $_SIZE -= &Def::read($INF, $ssample_delta, 4);
        $sample_count = unpack("N", $ssample_count);
        $sample_delta = unpack("N", $ssample_delta);
        print $_INDENT_, "sample count: ", $sample_count, "\n";
        print $_INDENT_, "sample delta: ", $sample_delta, "\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
