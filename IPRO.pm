#!/usr/bin/perl -w
package IPRO;
use strict;
use warnings;
use Switch;
use FullBox;
use SINF;

sub new ()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    
    &Def::header($_INDENT_, __PACKAGE__);
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    
    # read count
    my ($sprotection_count, $protection_count);
    $_SIZE -= &Def::read($INF, $sprotection_count, 2);
    $protection_count = unpack("n", $sprotection_count);
    print $_INDENT_, "protection count: ", $protection_count, "\n";

    # a loop
    for (;$protection_count>0;$protection_count--) {
        my ($header) = Box->new($INF);
        $_SIZE -= $header->get_size();
        $header->print($_INDENT_);
        
        die "type is not asserted.\n" if ($header->get_type() != "sinf");
        SINF->new($INF, $_SIZE);
    }
    if ($_SIZE != 0) {
        print $_INDENT_, "size != 0, I still need to seek. ;-) \n";
        seek($INF, $_SIZE, 1);
    }
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
