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
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];

    while($_SIZE > 0) {
        my $header = Box->new($INF, $counter);
        print "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
         switch($header->get_type()) {
            case "tkhd" {
                print "++++ TKHD ++++\n";
                TKHD->new($INF, $counter, $header->get_body_size());
                
                print "---- TKHD ----\n";
            }
            case "tref" {
                print "++++ TREF ++++\n";
                TREF->new($INF, $counter, $header->get_body_size());
                print "---- TREF ----\n";
            }
            case "edts" {
                print "++++ EDTS ++++\n";
                EDTS->new($INF, $counter, $header->get_body_size());
                print "---- EDTS ----\n";
            }
            case "mdia" {
                print "++++ MDIA ++++\n";
                MDIA->new($INF, $counter, $header->get_body_size());
                print "---- MDIA ----\n";
            }
            else {
                NULL->new($INF, $counter, $header->get_body_size());
            }
         }
    }
    seek($INF, $_SIZE, 1);
}

1;
