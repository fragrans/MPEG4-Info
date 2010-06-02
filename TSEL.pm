#!/usr/bin/perl -w
package TSEL;
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

    my ($sswitch_group,$attribute);
    my ($switch_group);

    $_SIZE -= &Def::read($INF, $sswitch_group);
    print $_INDENT_, "switch_group: ", $switch_group, "\n";

    while ($_SIZE > 0){
        $_SIZE -= &Def::read($INF, $attribute, 4);
        print $_INDENT_, "abbribute: ", $attribute, "\n";
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
