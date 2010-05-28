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
    $_SIZE = $_[3];
    $counter = $_[2];

    while ($_SIZE > 0) {
        my ($header) = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "hdlr" {
                print $_INDENT_, "++++ HDLR ++++\n";
                HDLR->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- HDLR ----\n";
            }
            case "dinf" {
                print $_INDENT_, "++++ DINF ++++\n";
                DINF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- DINF ----\n";
            }
            case "ipmc" {
                print $_INDENT_, "++++ IPMC ++++\n";
                IPMC->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- IPMC ----\n";
            }
            case "iloc" {
                print $_INDENT_, "++++ ILOC ++++\n";
                ILOC->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- ILOC ----\n";
            }
            case "ipro" {
                print $_INDENT_, "++++ IPRO ++++\n";
                IPRO->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- IPRO ----\n";
            }
            case "iinf" {
                print $_INDENT_, "++++ IINF ++++\n";
                IINF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- IINF ----\n";
            }
            case "xml " {
                print $_INDENT_, "++++ XML  ++++\n";
                XML->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- XML  ----\n";
            }
            case "bxml" {
                print $_INDENT_, "++++ BXML ++++\n";
                BXML->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- BXML ----\n";
            }
            case "pitm" {
                print $_INDENT_, "++++ PITM ++++\n";
                PITM->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- PITM ----\n";
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
