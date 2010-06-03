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

@ISA = ("Box");

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

 
    my $DELIMITER = $Def::DELIMITER;

    # full box
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    
    my ($sentry_count, $entry_count);
    $_SIZE -= &Def::read($INF, $sentry_count, 4);
    $entry_count = unpack("N", $sentry_count);
    my $hash = {}; # hash reference
    my @params;
    my @subs;
    $hash->{'params'} = @params;
    $hash->{'subs'} = @subs;

    my ($i);
    
    for ($i=0; $i<$entry_count; $i++) {
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        switch($header->get_type()) {           
            case "soun" {
                AudioSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            case "vide" {
                VisualSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
           
            case "avc1" {
                VisualSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER, $header->get_type());                
            }            
            case "mp4a" 
            {
                AudioSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER, $header->get_type());    
            }
            case "mp4v" {
                VisualSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER, $header->get_type());    
            }
            case "mp4s" {
                HintSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER, $header->get_type());    
            }
            case "meta" {
                MetadataSampleEntry->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
            }
            else {
                NULL->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
        }
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;

}

sub print() {
    &Def::header($_INDENT_, __PACKAGE__);
    print $_INDENT_, "there are ", $_[0]->{'entry_count'}, " entries.\n";
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
