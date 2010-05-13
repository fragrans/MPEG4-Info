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

sub new()
{
    my ($_INF, $_SIZE, $counter);
    $_INF = $_[1];
    $_SIZE = $_[2];
    $counter = $_[3];
    my $objref = {};
    my $class = $_[0];
    while ($_SIZE > 0) {
        my ($header) = Box->new($_INF, $counter);
        print "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "moov" {
                print "++++ MOOV ++++\n";
                MOOV->new($_INF, $counter, $header->get_body_size());
                
                print "---- MOOV ----\n";
            }
            case "ftyp" {
                print "++++ FTYP ++++\n";
                FTYP->new($_INF, $counter, $header->get_body_size());
                print "---- FTYP ----\n";
            }
            case "pdin" {
                print "---- PDIN ----\n";
                PDIN->new($_INF, $counter, $header->get_body_size());
            }
            case "free" {
                print "++++ FREE ++++\n";
                FREE->new($_INF, $counter, $header->get_body_size());
                print "---- FREE ----\n";
            }
            case "mdat" {
                MDAT->new($_INF, $counter, $header->get_body_size());
            }
            case "moof" {
                MOOF->new($_INF, $counter, $header->get_body_size());
            }
            case "mfra" {
                MFRA->new($_INF, $counter, $header->get_body_size());
            }
            case "skip" {
                SKIP->new($_INF, $counter, $header->get_body_size());
            }
            case "meta" {
                META->new($_INF, $counter, $header->get_body_size());
            }
            case "meco" {
                MECO->new($_INF, $counter, $header->get_body_size());
            }
            case "uuid" {
                UUID->new($_INF, $counter, $header->get_body_size());
            }
            else {
                NULL->new($_INF, $counter, $header->get_body_size());
            }
        }
    }
    bless $objref, $class;
    return $class;
}

1;
