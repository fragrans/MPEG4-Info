#!/usr/bin/perl -w
package IPRO;
use strict;
use warnings;
use Switch;
use FullBox;
use SINF;

sub new ()
{
    my ($INF, $_SIZE, $counter);
    $INF = $_[1];
    $_SIZE = $_[3];
    $counter = $_[2];
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    $counter -= 4;
    
    # read count
    my ($sprotection_count, $protection_count);
    read $INF, $sprotection_count, 2 or die "read protection count failed. $!\n";
    $protection_count = unpack("n", $sprotection_count);
    print $_INDENT_, "protection count: ", $protection_count, "\n";
    $_SIZE -= 2;
    $counter -= 2;

    # a loop
    for (;$protection_count>0;$protection_count--) {
        my ($header) = Box->new($INF, $counter);
        print $_INDENT_, "box type: ", $header->get_type(), " box size: ", $header->get_size(), "\n";
        $counter -= $header->get_size();
        $_SIZE -= $header->get_size();
        
        die "type is not asserted.\n" if ($header->get_type() != "sinf");
        print $_INDENT_, "++++ SINF ++++\n";
        SINF->new($INF, $counter, $_SIZE);
        print $_INDENT_, "++++ SINF ++++\n";
    }
    if ($_SIZE != 0) {
        print $_INDENT_, "size != 0, I still need to seek. ;-) \n";
        seek($INF, $_SIZE, 1);
    }
}

1;
