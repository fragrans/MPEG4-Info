#!/usr/bin/perl -w
package Container;
use strict;
use warnings;

use File::stat;
use Switch;
use Def;
use Header;

# Container
sub new()
{
    my ($INF, $_SIZE, $_INDENT_);
    $INF = $_[1];
    $_SIZE = $_[2];
    $_INDENT_ = $_[3];

    my $DELIMITER = $Def::DELIMITER;

    while ($_SIZE > 0) {
        my $header = Header->new($INF);
	$_SIZE -= $header->get_size();
	switch ($header->get_type()) {
	    case "" {}
	    else {
                my $box = NULL->new($INF, $header);
		$box->print($_INDENT_);
	    }
	}
    }
    die __PACKAGE__ . ": Size ($_SIZE) is not zero.\n" if $_SIZE;
}

1;
