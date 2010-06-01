#!/usr/bin/perl -w
package SINF;
use strict;
use warnings;
use Switch;

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
            case "frma" {
                FRMA->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "imif" {
                IMIF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "schm" {
                SCHM->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "schi" {
                SCHI->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
        }
    }
    die "size is not 0, dying. ;-) \n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
