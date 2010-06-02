#!/usr/bin/perl -w
package MDHD;
use strict;
use warnings;
use Switch;

#
# Media header, overall information about the media
#
sub new ()
{
    die "I prefer 3 parameter, but I only got $#_\n" if $#_ != 3;
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
    
    my ($creation_time, $modification_time, $timescale, $timeduration);
    my ($screation_time, $smodification_time, $stimescale, $stimeduration);
    
    if ($version == 1) {
        $_SIZE -= &Def::read($INF, $screation_time, 8);
        $_SIZE -= &Def::read($INF, $smodification_time, 8);
        $_SIZE -= &Def::read($INF, $stimescale, 4);
        $_SIZE -= &Def::read($INF, $stimeduration, 8);

        $creation_time = unpack("Q>", $screation_time);
        $modification_time = unpack("Q>", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("Q>", $stimeduration);

    } elsif ($version == 0) {
        $_SIZE -= &Def::read($INF, $screation_time, 4);
        $_SIZE -= &Def::read($INF, $smodification_time, 4);
        $_SIZE -= &Def::read($INF, $stimescale, 4);
        $_SIZE -= &Def::read($INF, $stimeduration, 4);

        $creation_time = unpack("N", $screation_time);
        $modification_time = unpack("N", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("N", $stimeduration);
    } else {
        die "weild version found. \n";
    }

    # using http://www.epochconverter.com/ to get this difference
    # between two epoch standards
    #
    # Jan. 1. 1070 in UNIX
    # Jan. 1. 1904 in MPEG-4
    #
    #
    my  $epoch_diff = -2082844800;
    print $_INDENT_, "Creation Time: ". gmtime($creation_time + $epoch_diff) . "\n";
    print $_INDENT_, "Modification Time: ". gmtime($modification_time + $epoch_diff) . "\n";
    print $_INDENT_, "Time scale: ". $timescale . "\n";
    print $_INDENT_, "Time duration: ". $timeduration . " ( ". $timeduration/$timescale . ")\n";

    my ($slanguage,$spre_defined);
    my (@codes, $language, $pre_defined);

    $_SIZE -= &Def::read($INF, $slanguage, 2);
    $_SIZE -= &Def::read($INF, $spre_defined, 2);
    
    $language = unpack("n", $slanguage);
    $codes[0] = $language & 31;
    $codes[1] = ($language >> 5) & 31;
    $codes[2] = $language >> 10;
    $pre_defined = unpack("n", $spre_defined);
    
    foreach (@codes) {
        $_ += 0x60;
        $_ = chr($_);
    }
    print $_INDENT_, "codes: ", reverse(@codes), "\n";
    print $_INDENT_, "pre_defined: ", $pre_defined, "\n";
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
