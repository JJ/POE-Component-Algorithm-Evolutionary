use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Poe::Component::Algorithm::Evolutionary',
    AUTHOR              => 'JJ Merelo <jj@merelo.net>',
    VERSION_FROM        => 'lib/Poe/Component/Algorithm/Evolutionary.pm',
    ABSTRACT_FROM       => 'lib/Poe/Component/Algorithm/Evolutionary.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Poe-Component-Algorithm-Evolutionary-*' },
);
