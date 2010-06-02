#!/usr/bin/perl -w
package PDIN;
use warnings;
use Switch;

#
# Progressive download information
#

sub new ()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    &Def::header($_INDENT_, __PACKAGE__);
    
    # full box header, version and flag
    my $fh = FullBox->new($INF);
    $_SIZE -= $fh->get_size();
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    my ($rate, $initial_delay);
    my ($srate, $sinitial_delay);

    while ($_SIZE > 0) {
        $_SIZE -= &Def::read($INF, $srate, 4);
        $_SIZE -= &Def::read($INF, $sinitial_delay, 4);
        $rate = unpack("N", $srate);
        $initial_delay = unpack("N", $sinitial_delay);
        print $_INDENT_ . "rate: " . $rate;
        print $_INDENT_ . "initial_delay: ". $initial_delay;
    }
    die "size is not zero\n" if $SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
