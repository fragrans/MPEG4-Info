#!/usr/bin/perl -w

package Box;
use strict;
use warnings;

sub new()
{
    die "I prefer 3 parameters, but I only got $#_\n" if $#_ != 3;
    my ($self, $INF, $HEADER);
    $self = $_[0];
    $INF = $_[1];
    $HEADER = $_[2];
    my $params = ();
    my $subs = ();
    my $hash = {
	'header'=>$HEADER,
	'params' => $params,
	'subs' => $subs
    };
    &mov($INF);
    bless $hash, $self;
    $hash;
}
sub mov() {
    seek($_[1], $_[0]->{'header'}->get_body_size(), 1);
    print "box mov";
}
sub print() {
    $_[0]->{'header'}->print();
}
sub get_size() {
    $_[0]->{'header'}->get_size();
}
sub get_body_size() {
    $_[0]->{'header'}->get_body_size();
}
sub get_header_size() {
    $_[0]->{'header'}->get_header_size();
}
sub get_type() {
    $_[0]->{'header'}->get_type();
}
1;
