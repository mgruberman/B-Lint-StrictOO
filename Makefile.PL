#!perl
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'B::Lint::StrictOO',
    AUTHOR        => 'Josh ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/B/Lint/StrictOO.pm',
    ABSTRACT_FROM => 'lib/B/Lint/StrictOO.pm',
    PREREQ_PM     => {
        'B::Lint' => '1.09',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'B-Lint-StrictOO-*' },
);
