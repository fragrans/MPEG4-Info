#!/usr/bin/perl -w
package HDLR;
use strict;
use warnings;
use Switch;

my $handler;
#
# handler, at this level, the media (handler) type
#
sub new ()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];
    # full box header, version and flag
    my $fh = FullBox->new($INF);
    $fh->print($_INDENT_);
    my ($version, $flag);
    $version = $fh->get_version();
    $flag = $fh->get_flag();
    $_SIZE -= 4; #subtract the fullheader extension size
    
    my ($pre_defined, $handler_type, @reserved, $name);
    my ($spre_defined, $shandler_type, $sreserved);
    
    $_SIZE -= &Def::read($INF, $spre_defined, 4);
    $_SIZE -= &Def::read($INF, $shandler_type, 4);
    $_SIZE -= &Def::read($INF, $sreserved, 12);
    
    &Def::read($INF, $name, );

    $pre_defined = unpack("N", $spre_defined);
    $handler_type = $shandler_type;
    @reserved = unpack("N" x 3, $sreserved);
    
    print $_INDENT_, "pre_defined: ", $pre_defined, "\n";
    print $_INDENT_, "handler type: ", $handler_type, "\n";
    print $_INDENT_, "reserved: @reserved", "\n";
    print $_INDENT_, "name: ", $name, "\n";
    $_SIZE -= $_SIZE;

    die "size is not zero" if $_SIZE;
    
    &Def::footer($_INDENT_, __PACKAGE__);
}

1;
