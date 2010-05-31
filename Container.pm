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

$|++;

# Container
sub new()
{
    my ($_INF, $_SIZE, $counter, $_INDENT_);
    $_INF = $_[1];
    $_SIZE = $_[2];
    $counter = $_[3];
    $_INDENT_ = $_[4];
    my $DELIMITER = "\t";
    my $objref = {};
    my $class = $_[0];
    while ($_SIZE > 0) {
        my ($header) = Box->new($_INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "moov" {
                print $_INDENT_, "++++ MOOV ++++\n";
                MOOV->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                
                print $_INDENT_, "---- MOOV ----\n";
            }
            case "ftyp" {
                print $_INDENT_, "++++ FTYP ++++\n";
                FTYP->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "---- FTYP ----\n";
            }
            case "pdin" {
                print $_INDENT_, "---- PDIN ----\n";
                PDIN->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            case "free" {
                print $_INDENT_, "++++ FREE ++++\n";
                FREE->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print "---- FREE ----\n";
            }
            case "mdat" {
                print $_INDENT_, "++++ MDAT ++++\n";
                MDAT->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ MDAT ++++\n";
            }
            case "moof" {
                print $_INDENT_, "++++ MOOF ++++\n";
                MOOF->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print "++++ MOOF ++++\n";
            }
            case "mfra" {
                print $_INDENT_, "++++ MFRA ++++\n";
                MFRA->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ MFRA ++++\n";
            }
            case "skip" {
                print $_INDENT_, "++++ SKIP ++++\n";
                SKIP->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ SKIP ++++\n";
            }
            case "meta" {
                print $_INDENT_, "++++ META ++++\n";
                META->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ META ++++\n";
            }
            case "meco" {
                print $_INDENT_, "++++ MECO ++++\n";
                MECO->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ MECO ++++\n";
            }
            case "uuid" {
                print $_INDENT_, "++++ UUID ++++\n";
                UUID->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ UUID ++++\n";
            }
            else {
                print $_INDENT_, "++++ NULL ++++\n";
                NULL->new($_INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);
                print $_INDENT_, "++++ NULL ++++\n";
            }
        }
    }
    die "size is not zero in Container!\n" if $_SIZE;
    bless $objref, $class;
    return $class;
}

1;
