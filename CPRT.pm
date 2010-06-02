#!/usr/bin/perl -w
package CPRT;
use strict;
use warnings;
use Switch;

sub new ()
{
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

    my ($slanguage,$notice);
    my (@codes, $language);
    
    $_SIZE -= &Def::read($INF, $slanguage, 2);
    my $tmp = $_SIZE;
    $_SIZE -= &Def::read($INF, $notice, $_SIZE);
    
    $language = unpack("n", $slanguage);
    $codes[0] = $language & 31;
    $codes[1] = ($language >> 5) & 31;
    $codes[2] = $language >> 10;

    
    foreach (@codes) {
        $_ += 0x60;
        $_ = chr($_);
    }
    print $_INDENT_, "codes: ", reverse(@codes), "\n";
    print $_INDENT_, "notice [$tmp]: ", $notice, "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
