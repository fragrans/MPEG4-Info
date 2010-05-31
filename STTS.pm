#!/usr/bin/perl -w
package STTS;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";

    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size

    my ($sentry_count, $entry_count);
    read $INF, $sentry_count, 4 or die "failed to read entry count\n";
    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";
    $_SIZE -= 4;
    my ($i);
    for ($i = 0; $i < $entry_count; $i++) {
        my ($ssample_count, $ssample_delta);
        my ($sample_count, $sample_delta);
        
        read $INF, $ssample_count, 4 or die "failed to read sample count.";
        read $INF, $ssample_delta, 4 or die "failed to read sample delta.";
        $sample_count = unpack("N", $ssample_count);
        $sample_delta = unpack("N", $ssample_delta);
        print $_INDENT_, "sample count: ", $sample_count, "\n";
        print $_INDENT_, "sample delta: ", $sample_delta, "\n";
        $_SIZE -= 8;
    }
    die "size is not zero. \n" if $_SIZE;
}

1;
