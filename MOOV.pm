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
use Def;

#
# Container for all the metadata
#

sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    print $_INDENT_, "I prefer 3 parameterss, but I only have $#_\n" if $#_ != 3;
    
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;

    while($_SIZE>0) {
        my $header = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        switch($header->get_type()) {
            case "mvhd" {
                
                MVHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
#                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);                
            }
            case "trak" {
                TRAK->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "mvex" {
                MVEX->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "ipmc" {
                IMPC->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "udta" {
                UDTA->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "iods" {
                IODS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
        
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}
1;
