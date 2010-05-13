#!/usr/bin/perl -w
package MDIA;
use strict;
use warnings;
use Switch;
use MDHD;
use HDLR;
use MINF;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    while ($_SIZE > 0) {
        my ($header) = Box->new($INF, $counter);
        print "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "mdhd" {
                print "++++ MDHD ++++\n";
                MDHD->new($INF, $counter, $header->get_body_size());    
                print "---- MDHD ----\n";
            }
            case "hdlr" {
                print "++++ HDLR ++++\n";
                HDLR->new($INF, $counter, $header->get_body_size());    
                print "---- HDLR ----\n";
            }
            case "minf" {
                print "++++ MINF ++++\n";
                MINF->new($INF, $counter, $header->get_body_size());    
                print "---- MINF ----\n";
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
