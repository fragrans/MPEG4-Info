package Container;
use strict;
use warnings;
use File::stat;
use Box;
use qw {MOOV, FTYP, FREE, PDIN, MDAT, MOOF, MFRA, SKIP, META, MECO, UUID};

sub new()
{
    _INF = $_[1];
    $_SIZE = $_[2];
    $counter = $_[3];
    
    while ($_SIZE > 0) {
        my ($header) = Box->new(_INF);
        $header->iter();
        switch($header->get_type()) {
            case "moov" {
                MOOV->new(_INF, $counter, $header->get_size());
            }
            case "ftyp" {
                FTYP->new(_INF, $counter, $header->get_size());
            }
            case "pdin" {
                PDIN->new(_INF, $counter, $header->get_size());
            }
            case "free" {
                FREE->new(_INF, $counter, $header->get_size());
            }
            case "mdat" {
                MDAT->new(_INF, $counter, $header->get_size());
            }
            case "moof" {
                MOOF->new(_INF, $counter, $header->get_size());
            }
            case "mfra" {
                MFRA->new(_INF, $counter, $header->get_size());
            }
            case "skip" {
                SKIP->new(_INF, $counter, $header->get_size());
            }
            case "meta" {
                META->new(_INF, $counter, $header->get_size());
            }
            case "meco" {
                MECO->new(_INF, $counter, $header->get_size());
            }
            case "uuid" {
                UUID->new(_INF, $counter, $header->get_size());
            }
            else {
                NULL->new(_INF, $counter, $header->get_size());
            }
        }
    }
}
