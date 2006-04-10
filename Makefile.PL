use strict;
use warnings;
use ExtUtils::MakeMaker;
use B::Lint;

WriteMakefile(
    NAME          => 'B::Lint::StrictOO',
    AUTHOR        => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/B/Lint/StrictOO.pm',
    ABSTRACT_FROM => 'lib/B/Lint/StrictOO.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More' => 0,
        !B::Lint->can('register_plugin') ? ( 'B::Lint::Pluggable' => 0 ) : ()
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'B-Lint-StrictOO-*' },
);
