#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'B::Lint::StrictOO' );
}

diag( "Testing B::Lint::StrictOO $B::Lint::StrictOO::VERSION, Perl $], $^X" );
