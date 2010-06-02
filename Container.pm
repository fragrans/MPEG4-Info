#!/usr/bin/perl -w
package Container;
use strict;
use warnings;

use File::stat;
use Switch;
use MOOV;
use FTYP;
use FREE;
use PDIN;
use MDAT;
use MOOF;
use MFRA;
use SKIP;
use MECO;
use UUID;
use NULL;
use Def;

$|++;

# Container
sub new()
{
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
            case "moov" {
                MOOV->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);                
            }
            case "ftyp" {
                FTYP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "pdin" {
                PDIN->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "free" {
                FREE->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "mdat" {
                MDAT->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "moof" {
                MOOF->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "mfra" {
                MFRA->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "skip" {
                SKIP->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "meta" {
                META->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "meco" {
                MECO->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "uuid" {
                UUID->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
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
