#!/usr/bin/perl -w
package HintSampleEntry;
use strict;
use warnings;
use Switch;

use SampleTable;

#
# Hine sample table
#
sub new ()
{
    die "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    my ($INF, $_SIZE, $_INDENT_, $_CODING_NAME);
    
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    $_CODING_NAME = $_[4];
    
    &Def::header($_INDENT_, __PACKAGE__);
    my $DELIMITER = $Def::DELIMITER;
    my $st = SampleTable->new($INF);
    $_SIZE -= $st->get_size();
    $st->print($_INDENT_);

    my (@reserved, $data_reference_index);
    @reserved = $st->get_reserved();
    $data_reference_index = $st->get_data_reference_index();
    print $_INDENT_, "Coding Name: ", $_CODING_NAME, "\n";
    while ($_SIZE > 0) {
        print $_INDENT_, "size: ", $_SIZE, "\n";
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        
        switch($header->get_type()) {
            case "esds" {
                ESDS->new($INF, $header->get_body_size(), $_INDENT_ . $DELIMITER);
            }
            else {
                die "unknown type in Visual sample entry.\n";
            }
        }
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
