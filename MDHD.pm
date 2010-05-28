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
    my ($INF, $_SIZE, $counter, $_INDENT_);

    print "I prefer 4 parameter, but I only got $#_\n" if $#_ != 4;
    $INF = $_[1];
    $counter = $_[2];
    $_SIZE = $_[3];
    $_INDENT_ = $_[4];
    
    my $fh = FullBox->new($INF);
    print $_INDENT_, "version: ", $fh->get_version(), "flag: ", $fh->get_flag(), " \n";
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($creation_time, $modification_time, $timescale, $timeduration);
    my ($screation_time, $smodification_time, $stimescale, $stimeduration);
    
    if ($version == 1) {
        read $INF, $screation_time, 8 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 8 or die "failed to read modification time!\n";
        read $INF, $stimescale, 4 or die "failed to read timescale!\n";
        read $INF, $stimeduration, 8 or die "failed to read timeduration!\n";

        $creation_time = unpack("Q>", $screation_time);
        $modification_time = unpack("Q>", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("Q>", $stimeduration);

        $_SIZE -= 28;
    } elsif ($version == 0) {
        read $INF, $screation_time, 4 or die "failed to read creation time!\n";
        read $INF, $smodification_time, 4 or die "failed to read modification time!\n";
        read $INF, $stimescale, 4 or die "failed to read timescale!\n";
        read $INF, $stimeduration, 4 or die "failed to read timeduration!\n";

        $creation_time = unpack("N", $screation_time);
        $modification_time = unpack("N", $smodification_time);
        $timescale = unpack("N", $stimescale);
        $timeduration = unpack("N", $stimeduration);
        $_SIZE -= 16;
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

    read $INF, $slanguage, 2 or die "read language failed.";
    read $INF, $spre_defined, 2 or die "read pre_defined failed";
    
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
    $_SIZE -= 4;
    die  "I still need to seek $_SIZE to find next token\n" if $_SIZE;
}

1;
