# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl callback-hook.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 3 };
use callback::hook;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


sub hook_test{
	# the existence of this subroutine
	# will get it listed in @callback::hook::hook_test
	return @_;
};

callback::hook::test(1,2,3);

ok($callback::hook::results{\&hook_test}->[1] == 2);

ok(!defined(callback::hook::bogus()));




	
