use strict;
use warnings;

package L;

use Class::Accessor::Lite (
    new => 1,
    rw  => {
        foo       => 1,
        bar       => undef,
    },
    ro  => {
        tokuhirom => 2,
    },
    wo  => {
        yappo     => 3,
    },
);

package M;

use Class::Accessor::Lite (
    new => 1,
    rw  => {
        hidek => sub { 40 },
        
    },
);
use base qw(L);

use Test::More tests => 32;

for (1..2) { # L::new is replaced at the first invocation
    my $l = L->new();
    is ref($l), 'L';
    is $l->foo, 1;
    $l->foo(0);
    is $l->foo, 0;
    ok ! defined $l->bar;
    is $l->tokuhirom, 2;
    is $l->{yappo}, 3;
    $l->yappo(4);
    is $l->{yappo}, 4;
}

for (1..2) {
    my $m = M->new(
        foo => 39,
    );
    is ref($m), 'M';
    is $m->foo, 39;
    ok ! defined $m->bar;
    is $m->tokuhirom, 2;
    is $m->{yappo}, 3;
    $m->yappo(4);
    is $m->{yappo}, 4;
    is $m->hidek, 40;
    $m->hidek(41);
    is $m->hidek, 41;
    $m = M->new(
        hidek => 42,
    );
    is $m->hidek, 42;
}
