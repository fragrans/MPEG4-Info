#!/usr/bin/perl -w
package VMHD;
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
    
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($sgraphicmode, $sopcolor);
    my ($graphicmode, @opcolor);
    read $INF, $sgraphicmode, 2 or die "failed to read graphic mode.\n";
    read $INF, $sopcolor, 6 or die "failed to read opcolor.\n";
    $graphicmode = unpack("n", $sgraphicmode);
    @opcolor = unpack("nnn", $sopcolor);
    print $_INDENT_, "graphic mode: ", $graphicmode, "\n";
    print $_INDENT_ ,"opcolor: ", "@opcolor", "\n";
    $_SIZE -= 8;
    die $_INDENT_ . "VMHD size is not zero.\n" if $_SIZE;
}

1;
