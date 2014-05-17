#!/usr/bin/perl

use strict;
use warnings;
use 5.006;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Barbie <barbie@cpan.org>',
    NAME                => 'WWW-Scraper-ISBN-Driver',
    VERSION_FROM        => 'lib/WWW/Scraper/ISBN/Driver.pm',
    ABSTRACT            => 'Driver class for WWW::Scraper::ISBN module',
    NO_META             => 1,
    PREREQ_PM           => {

        # runtime prereqs
		'Carp'                          => '1.00',

        # build/test prereqs
        'IO::File'                      => '0',
        'Test::More'                    => '0.70'

    }
);
