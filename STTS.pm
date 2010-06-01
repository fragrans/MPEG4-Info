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
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size

    my ($sentry_count, $entry_count);
    &Def::read($INF, $sentry_count, 4);
    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";
    $_SIZE -= 4;
    my ($i);
    for ($i = 0; $i < $entry_count; $i++) {
        my ($ssample_count, $ssample_delta);
        my ($sample_count, $sample_delta);
        
        &Def::read($INF, $ssample_count, 4);
        &Def::read($INF, $ssample_delta, 4);
        $sample_count = unpack("N", $ssample_count);
        $sample_delta = unpack("N", $ssample_delta);
        print $_INDENT_, "sample count: ", $sample_count, "\n";
        print $_INDENT_, "sample delta: ", $sample_delta, "\n";
        $_SIZE -= 8;
    }
    die "size is not zero. \n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
