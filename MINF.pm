#!/usr/bin/perl -w
package MINF;
use strict;
use warnings;
use Switch;
use VMHD;
use SMHD;
use HMHD;
use NMHD;
use DINF;
use STBL;

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
            case "vmhd" {
                print "++++ VMHD ++++\n";
                VMHD->new($INF, $counter, $header->get_body_size());    
                print "---- VMHD ----\n";
            }
            case "smhd" {
                print "++++ SMHD ++++\n";
                SMHD->new($INF, $counter, $header->get_body_size());    
                print "---- SMHD ----\n";
            }
            case "hmhd" {
                print "++++ HMHD ++++\n";
                HMHD->new($INF, $counter, $header->get_body_size());    
                print "---- HMHD ----\n";
            }
            case "nmhd" {
                print "++++ NMHD ++++\n";
                NMHD->new($INF, $counter, $header->get_body_size());    
                print "---- NMHD ----\n";
            }
            case "dinf" {
                print "++++ DINF ++++\n";
                DINF->new($INF, $counter, $header->get_body_size());    
                print "---- DINF ----\n";
            }
            case "stbl" {
                print "++++ STBL ++++\n";
                STBL->new($INF, $counter, $header->get_body_size());    
                print "---- STBL ----\n";
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
