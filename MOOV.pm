#!/usr/bin/perl -w
package MOOV;
use warnings;
use strict;
use Switch;
use Box;
use MVHD;
use TRAK;
use MVEX;
use IPMC;
use IODS;
use UDTA;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    
    while($_SIZE>0) {
        my $header = Box->new($INF, $counter);
        print "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "mvhd" {
                print "++++ MVHD ++++\n";
                MVHD->new($INF, $counter, $header->get_body_size());                
                print "---- MVHD ----\n";
            }
            case "trak" {
                print "++++ TRAK ++++\n";
                TRAK->new($INF, $counter, $header->get_body_size());
                print "---- TRAK ----\n";
            }
            case "mvex" {
                print "++++ MVEX ++++\n";
                MVEX->new(*$INF{IO}, $counter, $header->get_body_size());
            }
            case "ipmc" {
                print "++++ IPMC ++++\n";
                IMPC->new(*$INF{IO}, $counter, $header->get_body_size());
                print "---- IPMC ----\n";
            }
            case "udta" {
                print "++++ UDTA ++++\n";
                UDTA->new(*$INF{IO}, $counter, $header->get_body_size());
                print "---- UDTA ----\n";
            }
            case "iods" {
                print "++++ IODS ++++\n";
                IODS->new(*$INF{IO}, $counter, $header->get_body_size());
                print "---- IODS ----\n";
            }
            else {
                print "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size());
                print "---- NULL ----\n";
            }
        }
        
    }
    seek($INF, $_SIZE, 1);
}

1;
