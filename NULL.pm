#!/usr/bin/perl -w
package NULL;
use strict;
use warnings;
use Switch;
use Box;

@NULL::ISA = ('Box');

sub new ()
{
    my ($self, $INF, $HEADER);
    die "I prefer 2 parameters, but I only got $#_\n" if $#_ != 2;
    $self = $_[0];
    $INF = $_[1];
    $HEADER = $_[2];
    seek($INF, $HEADER->get_body_size(), 1);
    my $hash = {
	'header'=>$HEADER,
	'extension'=>undef,
	'size'=>$HEADER->get_body_size()
    };
    bless $hash, $self;
    $hash;
}
sub print()
{
    $_[0]->{'header'}->print($_[1]);
}
sub mov() {
    seek($_[1], $_[0]->{'header'}->get_body_size(), 1);
    print "null mov";
}
1;
