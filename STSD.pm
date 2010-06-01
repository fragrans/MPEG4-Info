#!/usr/bin/perl -w
package STSD;
use strict;
use warnings;
use Switch;

use Box;
use FullBox;

use VisualSampleEntry;
use AudioSampleEntry;
use HintSampleEntry;
use MetaDataSampleEntry;
use MP4A;
use MP4S;
use MP4V;
use AVC1;
#
# Sample Description Box
#
sub new ()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;

    # full box
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($sentry_count, $entry_count);
    read $INF, $sentry_count, 4 or die "failed to read entry count\n";
    $entry_count = unpack("N", $sentry_count);
    print $_INDENT_, "there are $entry_count entries.\n";
    $_SIZE -= 4;
    
    my ($i);
    
    for ($i=0; $i<$entry_count; $i++) {
        my ($header) = Box->new($INF);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {

           
            case "soun" {
                AudioSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "vide" {
                VisualSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
           
            case "avc1" {
                AVC1->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            
            case "mp4a" {
                MP4A->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            
            case "mp4v" {
                MP4V->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "mp4s" {
                MP4S->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "hint" {
                HintSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "meta" {
                MetadataSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
           
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
    }
    die "STSD size ($_SIZE) is not null. \n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
