#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'SimpleConfig' );
}

diag( "Testing SimpleConfig $SimpleConfig::VERSION, Perl $], $^X" );
