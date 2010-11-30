package Class::Accessor::Lite;

use strict;

our $VERSION = '0.02';

sub mk_accessors {
    shift; # usage: Class::Accessor::Lite->mk_accessors(qw(...));
    no strict 'refs';
    my $pkg = caller(0);
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

__END__

=head1 NAME

Class::Accessor::Lite - a minimalistic variant of Class::Accessor

=head1 SYNOPSIS

package MyPackage;

use Class::Accessor::Lite;

Class::Accessor::Lite->mk_accessors(qw(foo bar));

=head1 DESCRIPTION

This is a minimalitic variant of C<Class::Accessor> and its alikes.

It is intended to be standalone and minimal, so that it can be copy & pasted into individual perl script files.

=head1 FUNCTIONS

=head2 Class::Accessor::Lite->mk_accessors(@name_of_the_properties)

Creates an accessor in current package under the name specified by the arguments that access the properties (of a hashref) with the same name.

=head1 FAQ

=head2 What happens when passing more than one arguments to the accessor?

When the accessor built by Class::Accessor::Lite is given more than one arguments, a reference to the arguments will be saved as an arrayref.  This behaviour might not be necessary but is implemented as is to maintain compatibility with L<Class::Accessor::Fast>.

    my @data = (1, 2, 3);
    $obj->someproperty(@data);

    $obj->someproperty->[2]++; # $data[3] is incremented

In general, you should pass an arrayref to set an arrayref to a property.

    my @data = (1, 2, 3);
    $obj->someproperty([ @data ]); # save a copy using arrayref

    $obj->someproper->[2]++; # @data is not modified

=head1 AUTHORS

Copyright (C) 2008 - 2010 Kazuho Oku

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.6 or, at your option, any later version of Perl 5 you may have available.

=head1 SEE ALSO

C<Class::Accessor>
