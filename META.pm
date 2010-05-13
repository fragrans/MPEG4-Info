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
        print "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "hdlr" {
                print "++++ HDLR ++++\n";
                HDLR->new($INF, $counter, $header->get_body_size());    
                print "---- HDLR ----\n";
            }
            case "dinf" {
                print "++++ DINF ++++\n";
                DINF->new($INF, $counter, $header->get_body_size());    
                print "---- DINF ----\n";
            }
            case "ipmc" {
                print "++++ IPMC ++++\n";
                IPMC->new($INF, $counter, $header->get_body_size());    
                print "---- IPMC ----\n";
            }
            case "iloc" {
                print "++++ ILOC ++++\n";
                ILOC->new($INF, $counter, $header->get_body_size());    
                print "---- ILOC ----\n";
            }
            case "ipro" {
                print "++++ IPRO ++++\n";
                IPRO->new($INF, $counter, $header->get_body_size());    
                print "---- IPRO ----\n";
            }
            case "iinf" {
                print "++++ IINF ++++\n";
                IINF->new($INF, $counter, $header->get_body_size());    
                print "---- IINF ----\n";
            }
            case "xml " {
                print "++++ XML  ++++\n";
                XML->new($INF, $counter, $header->get_body_size());    
                print "---- XML  ----\n";
            }
            case "bxml" {
                print "++++ BXML ++++\n";
                BXML->new($INF, $counter, $header->get_body_size());    
                print "---- BXML ----\n";
            }
            case "pitm" {
                print "++++ PITM ++++\n";
                PITM->new($INF, $counter, $header->get_body_size());    
                print "---- PITM ----\n";
            }
            else {
                print "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size());    
                print "---- NULL ----\n";
            }
        }
    }
    seek($INF, $_SIZE, 1);
}
1;
