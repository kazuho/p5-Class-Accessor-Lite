package Class::Accessor::Lite;

use strict;

our $VERSION = '0.01';

sub mk_accessors {
    shift; # usage: Class::Accessor::Lite->mk_accessors(qw(...));
    no strict 'refs';
    my $pkg = caller(1);
    for my $n (@_) {
        *{$pkg . '::' . $n} = __m($n);
    }
}

sub __m {
    my $n = shift;
    sub {
        return $_[0]->{$n} if @_ == 1;
        return $_[0]->{$n} = $_[1] if @_ == 2;
        shift->{$n} = \@_;
    };
}

1;
