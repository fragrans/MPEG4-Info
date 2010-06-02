#!/usr/bin/perl -w
package HINT;
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
    my ($strack_id, @track_id);
    my $tmp = $_SIZE;
    $_SIZE -= &Def::read($INF, $strack_id, $_SIZE);
    @track_id = unpack("N" x $tmp, $strack_id);
    print $_INDENT_, "track id", "@track_id", "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
