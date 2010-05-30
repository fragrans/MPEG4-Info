#!/usr/bin/perl -w
package DINF;
use strict;
use warnings;
use Switch;
use URL;
use URN;
use DREF;

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
            case "url" {
                print $_INDENT_, "++++ URL ++++\n";
                URL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- URL ----\n";
            }
            case "urn" {
                print $_INDENT_, "++++ URN ++++\n";
                URN->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- URN ----\n";
            }
            case "dref" {
                print $_INDENT_, "++++ DREF ++++\n";
                DREF->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- DREF ----\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- NULL ----\n";
            }
        }
    }
    die "MINF size is not null. \n" if $_SIZE;

}

1;
