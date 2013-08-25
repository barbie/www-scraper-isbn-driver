package WWW::Scraper::ISBN::Driver;

use strict;
use warnings;

use Carp;

our $VERSION = '0.19';

# Preloaded methods go here.
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{FOUND} = 0;
	$self->{VERBOSITY} = 0;
	$self->{BOOK} = undef;
	$self->{ERROR} = "";
	bless ($self, $class);
	return $self;
}

sub found {
	my $self = shift;
	if (@_) { $self->{FOUND} = shift };
	return $self->{FOUND};
}

sub verbosity {
    my $self = shift;
    if (@_) { $self->{VERBOSITY} = shift };
    return $self->{VERBOSITY};
}

sub book {
    my $self = shift;
    if (@_) { $self->{BOOK} = shift };
    return $self->{BOOK};
}        

sub error {
	my $self = shift;
	if (@_) { $self->{ERROR} = shift };
	return $self->{ERROR};
}

sub search {
	croak(q{Child class must overload 'search()' method.});
}

# a generic method for storing the error & setting not found

sub handler {
	my $self = shift;
	if (@_) {
		$self->{ERROR} = shift;
		print "Error: $self->{ERROR}\n"	if $self->verbosity;
	};
	return $self->found(0);
}

1;

__END__

=head1 NAME

WWW::Scraper::ISBN::Driver - Driver class for WWW::Scraper::ISBN module.

=head1 SYNOPSIS

    use WWW::Scraper::ISBN::Driver;
    
    $driver = WWW::Scraper::ISBN::Driver->new();
    $driver->search($isbn);

    if ($driver->found) { ... }
    $driver->verbosity(1);
    
    my $book = $driver->book();
    print $book('title');
    print $driver->error;

=head1 REQUIRES

Requires the following modules be installed:

    Carp

=head1 DESCRIPTION

This is a base class, from which all site-specific drivers should inherit its 
members and methods.  Driver subclasses named 'C<$name>' should be packaged as 
C<WWW::Scraper::ISBN::$name_Driver>, e.g. C<WWW::Scraper::ISBN::LOC_Driver> 
for the LOC (Library of Congress) driver. Each driver need only implement the 
C<search()> method, though they may have as many other methods as they need to 
get their job done. Only C<search()> will be called by 
C<< WWW::Scraper::ISBN->search() >>.

=head2 Standard Fields

It is important that the different drivers return at least a core set of 
information, though they may return additional information.  The following 
self-explanatory fields should exist in C<< $driver->book >>:

=over 4

=item author

=item title

=item isbn

=back

In some cases, there may be no information for these fields, and so these may 
be set to the empty string. However, they must still be set in the hash! 

Additional standard fields may be added in the future. 'pages', 'weight', 
'height', 'depth and 'description' are common. 

=head2 Expiration

Due to the dynamic, ever-changing nature of the web, it is highly likely that 
the site from which many of these drivers glean their information will change.  
Hopefully, driver maintainers will keep drivers up to date, but they will all 
expire, and may behave unexpectedly.  Keep this in mind if the driver 
continually returns weird results.

=head1 METHODS

The following methods are provided by C<WWW::Scraper::ISBN::Driver>:

=over 4

=item C<new()>

    $drv = WWW::Scraper::ISBN::Driver->new()

Class constructor. Creates new driver object and returns a reference to it. 
Sets the following default values:

    found = 0;
    verbosity = 0;
    book = undef;
    error = '';

=item C<found() or found($bool)>

    if ($drv->found) { # ... }
    $drv->found(1);

Accessor/Mutator method for handling the search status of this record. This is 
0 by default, and should only be set true if search was deemed successful and 
C<< $driver->book >> contains appropriate information.

=item C<verbosity() or verbosity($level)>

    $driver->verbosity(3);
    if ($driver->verbosity == 2) { print 'blah blah blah'; }

Accessor/Mutator method for handling the verbosity level to be generated by 
this driver as it is going. This can be used to print useful information by 
the driver as it is running.

=item C<book() or book($hashref)>

    my $book = $drv->book;
    print $book->{'title'}; 
    print $book->{'author'};
    $another_book = { 'title' => 'Some book title',
        'author' => "Author of some book"
    };
    $drv->book( $another_book );

Accessor/Mutator method for handling the book information retrieved by the 
driver. The driver should create an anonymous hash containing the standard 
fields. C<< WWW::Scraper::ISBN->search >> sets the 
C<< WWW::Scraper::ISBN::Record->book() >> field to this value.

=item C<error() or error($error_string)>

    print $driver->error;
    $driver->error('Invalid ISBN number, or some similar error.');

Accessor/Mutator method for handling any errors which occur during the search.
The search drivers may add errors to record fields, which may be useful in 
gleaning information about failed searches.

=item C<search($isbn)>

    my $record = $driver->search('123456789X');

Searches for information on the given ISBN number. Each driver must define its
own search routine, doing whatever is necessary to retrieve the desired 
information. If found, it should set C<< $driver->found >> and 
C<< $driver->book >> accordingly.

=item C<handler() or handler($error_string)>

    $driver->handler('Invalid ISBN number, or some similar error.');

A generic handler method for handling errors.  If given an error string, will 
store as per C<< $self->error($error_string) >> and print on the standard 
output if verbosity is set.  Returns C<< $self->found(0) >>.

=head1 KNOWN DRIVERS

The current list of known drivers can be installed via the following Bundle:

=over 4

L<Bundle::WWW::Scraper::ISBN::Drivers>

=back

If you create a driver, please post a GitHub pull request or create an RT 
ticket against the Bundle distribution.

=head1 SEE ALSO

=over 4

L<WWW::Scraper::ISBN>

L<WWW::Scraper::ISBN::Record>

=back

=head1 AUTHOR

  2004-2013 Andy Schamp, E<lt>andy@schamp.netE<gt>
  2013      Barbie, E<lt>barbie@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

  Copyright 2004-2013 by Andy Schamp
  Copyright 2013 by Barbie

  This distribution is free software; you can redistribute it and/or
  modify it under the Artistic Licence v2.

=cut
