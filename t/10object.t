#!/usr/bin/perl -w
use strict;

use Test::More tests => 21;

use WWW::Scraper::ISBN::Driver;

my $driver = WWW::Scraper::ISBN::Driver->new();
isa_ok($driver,'WWW::Scraper::ISBN::Driver');
my $driver2 = $driver->new();
isa_ok($driver2,'WWW::Scraper::ISBN::Driver');

my %defaults = (
    found       => 0,
    verbosity   => 0,
    book        => undef,
    error       => ''
);

for my $method (qw( found verbosity book error )) {
    is($driver->$method(),$defaults{$method},".. default test for $method");
    is($driver->$method('value'),'value',".. value test for $method");
}

eval { $driver->search() };
like($@,qr/Child class/);

$driver->found(1);
is($driver->found,1);
is($driver->handler('this is an error'),0);
is($driver->found,0);
is($driver->error,'this is an error');
is($driver->handler(),0);
is($driver->error,'this is an error'); # stays the same, if no other error given

# now with verbose off

$driver->verbosity(0);

eval { $driver->search() };
like($@,qr/Child class/);

is($driver->handler('this is still an error'),0);
is($driver->found,0);
is($driver->error,'this is still an error');
