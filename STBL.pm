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
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";
    
     while ($_SIZE > 0) {
        my ($header) = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "stsd" {
                print $_INDENT_, "++++ STSD ++++\n";
                STSD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STSD ----\n";
            }
            case "stts" {
                print $_INDENT_, "++++ STTS ++++\n";
                STTS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STTS ----\n";
            }
            case "ctts" {
                print $_INDENT_, "++++ CTTS ++++\n";
                CTTS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- CTTS ----\n";
            }
            case "stsc" {
                print $_INDENT_, "++++ STSC ++++\n";
                STSC->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STSC ----\n";
            }
            case "stsz" {
                print $_INDENT_, "++++ STSZ ++++\n";
                STSZ->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STSZ ----\n";
            }
            case "stz2" {
                print $_INDENT_, "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STZ2 ----\n";
            }
            case "stco" {
                print $_INDENT_, "++++ STCO ++++\n";
                STCO->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STCO ----\n";
            }
            case "co64" {
                print $_INDENT_, "++++ CO64 ++++\n";
                CO64->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- CO64 ----\n";
            }
            case "stss" {
                print $_INDENT_, "++++ STSS ++++\n";
                STSS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STSS ----\n";
            }
            case "stsh" {
                print $_INDENT_, "++++ STSH ++++\n";
                STSH->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STSH ----\n";
            }
            case "padb" {
                print $_INDENT_, "++++ PADB ++++\n";
                PADB->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- PADB ----\n";
            }
            case "stdp" {
                print $_INDENT_, "++++ STDP ++++\n";
                STDP->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STDP ----\n";
            }
            case "sdtp" {
                print $_INDENT_, "++++ SDTP ++++\n";
                SDTP->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SDTP ----\n";
            }
            case "sbgp" {
                print $_INDENT_, "++++ SBGP ++++\n";
                SBGP->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SBGP ----\n";
            }
            case "sgpd" {
                print $_INDENT_, "++++ SGPD ++++\n";
                SGPD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SGPD ----\n";
            }
            case "subs" {
                print $_INDENT_, "++++ SUBS ++++\n";
                SUBS->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SUBS ----\n";
            }
            case "STZ2" {
                print $_INDENT_, "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STZ2 ----\n";
            }
            case "STZ2" {
                print $_INDENT_, "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STZ2 ----\n";
            }
            case "STZ2" {
                print $_INDENT_, "++++ STZ2 ++++\n";
                STZ2->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STZ2 ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }
    seek($INF, $_SIZE, 1);
}

1;
