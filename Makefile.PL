use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'WWW::Scraper::ISBN::Driver',
    'VERSION_FROM'	=> 'Driver.pm', # finds $VERSION
    'PREREQ_PM'		=> {
		Carp => 1.0
		},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
       (AUTHOR     => 'Andy Schamp <andy@schamp.net>') : ()),
);
