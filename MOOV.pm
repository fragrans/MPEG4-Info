#!/usr/bin/perl -w
package MOOV;
use warnings;
use strict;

use Switch;

use MVHD;
use TRAK;
use MVEX;
use IPMC;
use IODS;
use UDTA;

#
# Container for all the metadata
#

sub new ()
{
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my ($DELIMITER);
    $DELIMITER = "\t";
    print $_INDENT_, "I prefer 4 parameters, but I only have $#_\n" if $#_ != 4;
    while($_SIZE>0) {
        my $header = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "mvhd" {
                print $_INDENT_, "++++ MVHD ++++\n";
                MVHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);                
                print $_INDENT_, "---- MVHD ----\n";
            }
            case "trak" {
                print $_INDENT_, "++++ TRAK ++++\n";
                TRAK->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- TRAK ----\n";
            }
            case "mvex" {
                print $_INDENT_, "++++ MVEX ++++\n";
                MVEX->new(*$INF{IO}, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "ipmc" {
                print $_INDENT_, "++++ IPMC ++++\n";
                IMPC->new(*$INF{IO}, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- IPMC ----\n";
            }
            case "udta" {
                print $_INDENT_, "++++ UDTA ++++\n";
                UDTA->new(*$INF{IO}, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- UDTA ----\n";
            }
            case "iods" {
                print $_INDENT_, "++++ IODS ++++\n";
                IODS->new(*$INF{IO}, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- IODS ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- NULL ----\n";
            }
        }
        
    }
    die "size is not zero \n" if $_SIZE;
}
1;
