#!/usr/bin/perl -w
package SINF;
use strict;
use warnings;
use Switch;

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
            case "frma" {
                print $_INDENT_, "++++ FRMA ++++\n";
                FRMA->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- FRMA ----\n";
            }
            case "imif" {
                print $_INDENT_, "++++ IMIF ++++\n";
                IMIF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- IMIF ----\n";
            }
            case "schm" {
                print $_INDENT_, "++++ SCHM ++++\n";
                SCHM->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SCHM ----\n";
            }
            case "schi" {
                print $_INDENT_, "++++ SCHI ++++\n";
                SCHI->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- SCHI ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }
    die "size is not 0, dying. ;-) \n" if $_SIZE;
}

1;
