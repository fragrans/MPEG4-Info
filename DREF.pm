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
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my $DELIMITER = "\t";

    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= $fh->get_size(); #subtract the fullheader extension size
    
    my ($sentry_count, $entry_count);
    
    $_SIZE -= read $INF, $sentry_count, 4 or die "failed to read entry count\n";

    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";

    my ($i);
    for ($i = 0; $i < $entry_count; $i ++) {
	my $header;
	$header = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
	 switch($header->get_type()) {
            case "url " {
                print $_INDENT_, "++++ URL ++++\n";
                URL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- URL ----\n";
            }
            case "urn " {
                print $_INDENT_, "++++ URN ++++\n";
                URN->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- URN ----\n";
            }
            else {
		print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }

    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
        
}

1;
