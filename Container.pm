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
    my $objref = {};
    my $class = $_[0];
    while ($_SIZE > 0) {
        my ($header) = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
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
    die "size is not zero in Container!\n" if $_SIZE;
    bless $objref, $class;
    return $class;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
