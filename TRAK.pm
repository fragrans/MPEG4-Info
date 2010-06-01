#!/usr/bin/perl -w
package TRAK;
use warnings;
use strict;

use Switch;
use Box;
use TKHD;
use TREF;
use EDTS;
use MDIA;

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    while($_SIZE > 0) {
        my $header = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
         switch($header->get_type()) {             
            case "tkhd" {
                TKHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "tref" {
                TREF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
           }
            case "edts" {
                EDTS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "mdia" {
                MDIA->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
         }
    }
    die "TRAK size ($_SIZE) is not null!\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
