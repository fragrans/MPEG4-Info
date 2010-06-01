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
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= $fh->get_size(); #subtract the fullheader extension size
    
    my ($sentry_count, $entry_count);
    
    $_SIZE -= &Def::read($INF, $sentry_count, 4);

    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";

    my ($i);
    for ($i = 0; $i < $entry_count; $i ++) {
	my $header;
	$header = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
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

    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
        
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
