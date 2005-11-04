package callback::hook;

use 5.006002;
no strict;
use warnings;

use Carp;

our $VERSION = '0.1.0';

my @callers;
our %results;

sub import{
	push @callers, scalar caller();
};

INIT{

	foreach my $caller (@callers){
		while(my ($name, $value) = each %{"${caller}::"}){
			$name =~ /^hook_(.+)/ or next;
			defined \&{"${caller}::hook_$1"} or next;

			push @{$1},\&{"${caller}::hook_$1"};
		}; 
	};
};


sub AUTOLOAD{

	defined @{$AUTOLOAD}or return undef;

	foreach my $routine (@{$AUTOLOAD}){
		$results{$routine} = [$routine->(@_)];
	};

};


1;
__END__

=head1 NAME

callback::hook - unified hooks for system/module programming

=head1 SYNOPSIS

in module code that uses a callback, just define subroutines
that start "hook_"

  package my_foo_module;
  use callback::hook;
  sub hook_after_foo{
     print "foo phase is complete, after_foo hook got args: @_\n";
  };

in system code that calls callbacks, find them in the callback::hook 
name space.

  package mainfoo;
  ...
     callback::hook::before_foo($this);
     $this->do_the_foo;
     callback::hook::after_foo($this);
 

=head1 DESCRIPTION

Another in a continuing series of short, subtle CPAN modules,
callback::hook provides a standard interface for writing routines
that will get called at defined times in the processing internal to
a system, and a standard way for calling the routines at those
defined times.

=head2 defining hook_* subroutines

Right before beginning run-time, all packages that C<use callback::hook>
are scanned for subroutines with names matching /hook_(.+)/ and any such
subroutines are pushed onto @{"callback::hook::$1"} arrays.  

=head2 calling hooks

When code calls C<callback::hook::NAME>, all subroutines in
@callback::hook::NAME are executed, in array context, and the results
of each are stored in C<%callback::hook::results> under the coderef
as a key.

=head2 getting hook results

you can find out the result of the last call to your package's
coderef on the NAME hook by looking at the
@{$callback::hook::results{\&hook_NAME}} array.

=head2 EXPORT

None.  This module imports coderefs from the callers space and
lists them in arrays in its own space, rather than exporting
anything.

=head2 arguable bug and two workarounds for it

Only one subroutine per callback-name per package.  So if you need
to create multiple callbacks on the same hook, either directly manipulate
the @callback::hook::NAME array for your callback's name, or declare
each callback function in its own package, that all use callback::hook.


=head1 HISTORY

=over 8

=item 0.1.0

Written after reading about automatic callback discovery on the
qpsmtpd mailing list, in response to a request from Tim Bunce,
for possible use with DBI.

=back



=head1 SEE ALSO

please use rt.cpan.org for bug reports and feedback.

=head1 AUTHOR

David Nicol E<lt>davidnico@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by David Nicol

Released under GNU Public License version 2.  The author
does not believe that linking in a library for use constitutes
creation of a derivative work.

=cut
