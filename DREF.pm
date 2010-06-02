#!/usr/bin/perl -w
package DREF;
use warnings;
use strict;

use Switch;
use FullBox;
use URL;
use URN;

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
    my $DELIMITER = $Def::DELIMITER;

    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    
    my ($sentry_count, $entry_count);
    
    $_SIZE -= &Def::read($INF, $sentry_count, 4);

    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";

    my ($i);
    for ($i = 0; $i < $entry_count; $i ++) {
	my $header;
	$header = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);

	 switch($header->get_type()) {
            case "url " {
                URL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "urn " {
                URN->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
    }

    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
        
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
