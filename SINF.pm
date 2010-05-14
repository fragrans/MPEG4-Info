#!/usr/bin/perl -w
package SINF;
use strict;
use warnings;
use Switch;

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
            case "frma" {
                print "++++ FRMA ++++\n";
                FRMA->new($INF, $counter, $header->get_body_size());    
                print "---- FRMA ----\n";
            }
            case "imif" {
                print "++++ IMIF ++++\n";
                IMIF->new($INF, $counter, $header->get_body_size());    
                print "---- IMIF ----\n";
            }
            case "schm" {
                print "++++ SCHM ++++\n";
                SCHM->new($INF, $counter, $header->get_body_size());    
                print "---- SCHM ----\n";
            }
            case "schi" {
                print "++++ SCHI ++++\n";
                SCHI->new($INF, $counter, $header->get_body_size());    
                print "---- SCHI ----\n";
            }
            else {
                print "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size());    
                print "---- NULL ----\n";
            }
        }
    }
    die "size is not 0, dying. ;-) \n" if $_SIZE;
}

1;
