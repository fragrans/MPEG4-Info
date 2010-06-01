#!/usr/bin/perl -w
package VMHD;
use strict;
use warnings;
use Switch;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($sgraphicmode, $sopcolor);
    my ($graphicmode, @opcolor);
    &Def::read($INF, $sgraphicmode, 2);
    &Def::read($INF, $sopcolor, 6);
    $graphicmode = unpack("n", $sgraphicmode);
    @opcolor = unpack("nnn", $sopcolor);
    print $_INDENT_, "graphic mode: ", $graphicmode, "\n";
    print $_INDENT_ ,"opcolor: ", "@opcolor", "\n";
    $_SIZE -= 8;
    die $_INDENT_ . "VMHD size is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
