#!/usr/bin/perl -w
package URN;
use warnings;
use strict;

use Switch;
use FullBox;

#
# URN
#
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
    
    my ($location);
    &Def::read($INF, $location, $_SIZE);
    print $_INDENT_, "location: ", $location, "\n";
    $_SIZE -= $_SIZE;
    die "need some modification here. ;-!";
    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
