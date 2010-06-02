#!/usr/bin/perl -w
package UDTA;
use strict;
use warnings;
use Switch;

use TSEL;
use CPRT;
use META;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    my $DELIMITER = $Def::DELIMITER;
    &Def::header($_INDENT_, __PACKAGE__);

    
    while ($_SIZE > 0) {
        my $header;
	$header = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);

        switch($header->get_type()) {
            case "cprt" {
                CPRT->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "tsel" {
                TSEL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "meta" {
                META->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
    }
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
