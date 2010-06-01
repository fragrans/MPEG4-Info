#!/usr/bin/perl -w
package META;
use warnings;
use Switch;
use Box;
use FullBox;
use HDLR;
use DINF;
use IPMC;
use ILOC;
use IPRO;
use IINF;
use XML;
use BXML;
use PITM;

sub new ()
{
    my $INF;
    $INF = $_[1];
    $_SIZE = $_[2];

    while ($_SIZE > 0) {
        my ($header) = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "hdlr" {
                HDLR->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "dinf" {
                DINF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "ipmc" {
                IPMC->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "iloc" {
                ILOC->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "ipro" {
                IPRO->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "iinf" {
                IINF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "xml " {
                XML->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "bxml" {
                BXML->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "pitm" {
                PITM->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
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
