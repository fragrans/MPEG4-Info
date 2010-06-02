#!/usr/bin/perl -w
package TIMS;
use warnings;
use strict;

use Switch;
use FullBox;

#
# Movie header, overall declarations
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);

    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
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
    
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;        
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
