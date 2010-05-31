#!/usr/bin/perl -w
package URL;
use warnings;
use strict;

use Switch;
use FullBox;

#
# URL
#
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
    return if $_SIZE == 0;
    print "size is not zero yet.\n";
    my ($location);
    print $_INDENT_, "location size: $_SIZE\n";
    read $INF, $location, $_SIZE or die "failed to read location\n";
    print $_INDENT_, "location: ", $location, "\n";
    $_SIZE -= $_SIZE;
    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
        
}

1;
