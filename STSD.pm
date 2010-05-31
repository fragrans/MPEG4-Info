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

#
# Sample Description Box
#
sub new ()
{
    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    my ($INF, $_SIZE, $counter, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    my $DELIMITER = "\t";

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
        my ($header) = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        switch($header->get_type()) {
            case "soun" {
                print $_INDENT_, "++++ Audio Sample Entry ++++\n";
                AudioSampleEntry->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- Audio Sample Entry ----\n";
            }
            case "vide" {
                print $_INDENT_, "++++ Visual Sample Entry ++++\n";
                VisualSampleEntry->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- Visual Sample Entry ----\n";
            }
            case "avc1" {
                print $_INDENT_, "++++ Visual Sample Entry ++++\n";
                VisualSampleEntry->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- Visual Sample Entry ----\n";
            }
            case "hint" {
                print $_INDENT_, "++++ Hint Sample Entry ++++\n";
                HintSampleEntry->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- Hint Sample Entry ----\n";
            }
            case "meta" {
                print $_INDENT_, "++++ Metadata Sample Entry ++++\n";
                MetadataSampleEntry->new($INF, $counter, $header->get_body_size(), $_INDENT_ . $DELIMITER);    
                print $_INDENT_, "---- Metadata Sample Entry ----\n";
            }
            else {
                die "unknown type. at STSD.pm";
            }
        }
    }
    die "STSD size is not null. \n" if $_SIZE;
}

1;
