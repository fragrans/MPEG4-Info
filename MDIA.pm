#!/usr/bin/perl -w
package MDIA;
use strict;
use warnings;
use Switch;
use MDHD;
use HDLR;
use MINF;

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
           
            case "mdhd" {
                print $_INDENT_, "++++ MDHD ++++\n";
                MDHD->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- MDHD ----\n";
            }
            case "hdlr" {
                print $_INDENT_, "++++ HDLR ++++\n";
                HDLR->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- HDLR ----\n";
            }
            
            case "minf" {
                print $_INDENT_, "++++ MINF ++++\n";
                MINF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- MINF ----\n";
            }
            
            case "" {
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }
    
    die "size ($_SIZE) is not zero.\n" if $_SIZE;
}

1;
