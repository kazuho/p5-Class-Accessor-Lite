use strict;
use warnings;

package Base;

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

package Mixin;

use Class::Accessor::Lite (
    new => undef,
    rw  => {
        mixin => 'm',
        mixin_f => sub { 'f' },
    },
);

package Derived;

use Class::Accessor::Lite (
    new => 1,
    rw  => {
        hidek => sub { 40 },
    },
);
use base qw(Base Mixin);

use Test::More tests => 36;

for (1..2) { # Base::new is replaced at the first invocation
    my $obj = Base->new();
    is ref($obj), 'Base';
    is $obj->foo, 1;
    $obj->foo(0);
    is $obj->foo, 0;
    ok ! defined $obj->bar;
    is $obj->tokuhirom, 2;
    is $obj->{yappo}, 3;
    $obj->yappo(4);
    is $obj->{yappo}, 4;
}

for (1..2) {
    my $m = Derived->new(
        foo => 39,
    );
    is ref($m), 'Derived';
    is $m->foo, 39;
    ok ! defined $m->bar;
    is $m->tokuhirom, 2;
    is $m->{yappo}, 3;
    $m->yappo(4);
    is $m->{yappo}, 4;
    is $m->hidek, 40;
    $m->hidek(41);
    is $m->hidek, 41;
    is $m->mixin, 'm';
    is $m->mixin_f, 'f';
    $m = Derived->new(
        hidek => 42,
    );
    is $m->hidek, 42;
}
