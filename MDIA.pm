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
           
            case "mdhd" {
                MDHD->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "hdlr" {
                HDLR->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            
            case "minf" {
                MINF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            
            case "" {
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
        }
    }
    
    die "size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
