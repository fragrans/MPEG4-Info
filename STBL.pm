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

#
# The sample table contains all the time and data indexing 
# of the media samples in a track. 
# Using the tables here, it is possible to locate samples 
# in time, determine their type (e.g. I-frame or not), 
# and determine their size, container, 
# and offset into that container.
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    
     while ($_SIZE > 0) {
        my ($header) = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            
            case "stsd" {
                STSD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            
            case "stts" {
                STTS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "ctts" {
                CTTS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stsc" {
                STSC->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stsz" {
                STSZ->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stz2" {
                STZ2->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stco" {
                STCO->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "co64" {
                CO64->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stss" {
                STSS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stsh" {
                STSH->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "padb" {
                PADB->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "stdp" {
                STDP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "sdtp" {
                SDTP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "sbgp" {
                SBGP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "sgpd" {
                SGPD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "subs" {
                SUBS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "trak" {
                TRAK->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
        }
    }
    seek($INF, $_SIZE, 1);
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
