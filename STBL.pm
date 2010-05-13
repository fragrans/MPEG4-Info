#!/usr/bin/perl -w
package STBL;
use strict;
use warnings;
use Switch;
use STSD;
use STTS;
use CTTS;
use STSC;
use STSZ;
use STZ2;
use STCO;
use CO64;
use STSS;
use STSH;
use PADB;
use STDP;
use SDTP;
use SBGP;
use SGPD;
use SUBS;

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
            case "stsd" {
                print "++++ STSD ++++\n";
                STSD->new($INF, $counter, $header->get_body_size());    
                print "---- STSD ----\n";
            }
            case "stts" {
                print "++++ STTS ++++\n";
                STTS->new($INF, $counter, $header->get_body_size());    
                print "---- STTS ----\n";
            }
            case "ctts" {
                print "++++ CTTS ++++\n";
                CTTS->new($INF, $counter, $header->get_body_size());    
                print "---- CTTS ----\n";
            }
            case "stsc" {
                print "++++ STSC ++++\n";
                STSC->new($INF, $counter, $header->get_body_size());    
                print "---- STSC ----\n";
            }
            case "stsz" {
                print "++++ STSZ ++++\n";
                STSZ->new($INF, $counter, $header->get_body_size());    
                print "---- STSZ ----\n";
            }
            case "stz2" {
                print "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size());    
                print "---- STZ2 ----\n";
            }
            case "stco" {
                print "++++ STCO ++++\n";
                STCO->new($INF, $counter, $header->get_body_size());    
                print "---- STCO ----\n";
            }
            case "co64" {
                print "++++ CO64 ++++\n";
                CO64->new($INF, $counter, $header->get_body_size());    
                print "---- CO64 ----\n";
            }
            case "stss" {
                print "++++ STSS ++++\n";
                STSS->new($INF, $counter, $header->get_body_size());    
                print "---- STSS ----\n";
            }
            case "stsh" {
                print "++++ STSH ++++\n";
                STSH->new($INF, $counter, $header->get_body_size());    
                print "---- STSH ----\n";
            }
            case "padb" {
                print "++++ PADB ++++\n";
                PADB->new($INF, $counter, $header->get_body_size());    
                print "---- PADB ----\n";
            }
            case "stdp" {
                print "++++ STDP ++++\n";
                STDP->new($INF, $counter, $header->get_body_size());    
                print "---- STDP ----\n";
            }
            case "sdtp" {
                print "++++ SDTP ++++\n";
                SDTP->new($INF, $counter, $header->get_body_size());    
                print "---- SDTP ----\n";
            }
            case "sbgp" {
                print "++++ SBGP ++++\n";
                SBGP->new($INF, $counter, $header->get_body_size());    
                print "---- SBGP ----\n";
            }
            case "sgpd" {
                print "++++ SGPD ++++\n";
                SGPD->new($INF, $counter, $header->get_body_size());    
                print "---- SGPD ----\n";
            }
            case "subs" {
                print "++++ SUBS ++++\n";
                SUBS->new($INF, $counter, $header->get_body_size());    
                print "---- SUBS ----\n";
            }
            case "STZ2" {
                print "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size());    
                print "---- STZ2 ----\n";
            }
            case "STZ2" {
                print "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size());    
                print "---- STZ2 ----\n";
            }
            case "STZ2" {
                print "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size());    
                print "---- STZ2 ----\n";
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
