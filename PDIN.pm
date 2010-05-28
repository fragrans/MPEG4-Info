#!/usr/bin/perl -w
package PDIN;
use warnings;
use Switch;

#
# Progressive download information
#

sub new ()
{
    my ($INF, $counter, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];

    # full box header, version and flag
    my $fh = FullBox->new($INF);
    print $_INDENT_, "version: ", $fh->get_version(), "flag: ", $fh->get_flag(), " \n";
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    my ($rate, $initial_delay);
    my ($srate, $sinitial_delay);

    while ($_SIZE > 0) {
        read $INF, $srate, 4 or die "fail to read rate";
        read $INF, $sinitial_delay, 4 or die "fail to read initial delay";
        $rate = unpack("N", $srate);
        $initial_delay = unpack("N", $sinitial_delay);
        print $_INDENT_ . "rate: " . $rate;
        print $_INDENT_ . "initial_delay: ". $initial_delay;
        $_SIZE -= 8;
    }
    die "size is not zero\n" if $SIZE;
}

1;
