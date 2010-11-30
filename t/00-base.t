package K;

use strict;
use warnings;

use Test::More tests => 8;

use_ok('Class::Accessor::Lite');

Class::Accessor::Lite->mk_accessors(qw(foo bar));

ok(! $@, 'call mk_accessors');

my $k = bless { foo => 1, bar => 2 }, 'K';
is($k->foo, 1);
is($k->foo(2), 2);
is($k->foo, 2);
is_deeply($k->foo(2, 3), [ 2, 3 ]);
is_deeply($k->foo, [ 2, 3 ]);
is($k->bar, 2);
