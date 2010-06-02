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
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;

    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    
     while ($_SIZE > 0) {
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        switch($header->get_type()) {
            case "vmhd" {
                VMHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "smhd" {
                SMHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "hmhd" {
                HMHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "nmhd" {
                NMHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "dinf" {
                DINF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
           
            case "stbl" {
                STBL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
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
