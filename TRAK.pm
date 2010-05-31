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
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";
    while($_SIZE > 0) {
        my $header = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
         switch($header->get_type()) {             
            case "tkhd" {
                print $_INDENT_, "++++ TKHD ++++\n";
                TKHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- TKHD ----\n";
            }
            case "tref" {
                print $_INDENT_, "++++ TREF ++++\n";
                TREF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- TREF ----\n";
           }
            case "edts" {
                print $_INDENT_, "++++ EDTS ++++\n";
                EDTS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- EDTS ----\n";
            }
            case "mdia" {
                print $_INDENT_, "++++ MDIA ++++\n";
                MDIA->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- MDIA ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- NULL ----\n";
            }
         }
    }
    die "TRAK size ($_SIZE) is not null!\n" if $_SIZE;
}

1;
