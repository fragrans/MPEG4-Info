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
use FREE;
use ILST;

sub new ()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    
    while ($_SIZE > 0) {
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
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
            case "ilst" {
                ILST->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "pitm" {
                PITM->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "free" {
                FREE->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
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
