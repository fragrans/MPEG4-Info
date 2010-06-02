#!/usr/bin/perl -w
package VMHD;
use strict;
use warnings;
use Switch;

sub new ()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
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
    
    my ($sgraphicmode, $sopcolor);
    my ($graphicmode, @opcolor);
    $_SIZE -= &Def::read($INF, $sgraphicmode, 2);
    $_SIZE -= &Def::read($INF, $sopcolor, 6);
    $graphicmode = unpack("n", $sgraphicmode);
    @opcolor = unpack("nnn", $sopcolor);
    print $_INDENT_, "graphic mode: ", $graphicmode, "\n";
    print $_INDENT_ ,"opcolor: ", "@opcolor", "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
