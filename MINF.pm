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

#
# Media information container
#
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
            case "vmhd" {
                print $_INDENT_, "++++ VMHD ++++\n";
                VMHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- VMHD ----\n";
            }
            case "smhd" {
                print $_INDENT_, "++++ SMHD ++++\n";
                SMHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SMHD ----\n";
            }
            case "hmhd" {
                print $_INDENT_, "++++ HMHD ++++\n";
                HMHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- HMHD ----\n";
            }
            case "nmhd" {
                print $_INDENT_, "++++ NMHD ++++\n";
                NMHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NMHD ----\n";
            }
            case "dinf" {
                print $_INDENT_, "++++ DINF ++++\n";
                DINF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- DINF ----\n";
            }
            case "stbl" {
                print $_INDENT_, "++++ STBL ++++\n";
                STBL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- STBL ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }
    die "MINF size is not null. \n" if $_SIZE;
}

1;
