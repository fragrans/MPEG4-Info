#!/usr/bin/perl -w
package CO64;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    seek($INF, $_SIZE, 1);
    &Def::header($_INDENT_, __PACKAGE__);
     my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();

    my ($sentry_count, $entry_count);
    $_SIZE -= &Def::read($INF, $sentry_count, 8);
    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";
    my ($i);
    for ($i = 0; $i < $entry_count; $i++) {
        my ($schunk_offset, $chunk_offset);
        $_SIZE -= &Def::read($INF, $schunk_offset, 8);
        $chunk_offset = unpack(">Q", $schunk_offset);
        print $_INDENT_, "chunk offset: ", $chunk_offset, "\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
