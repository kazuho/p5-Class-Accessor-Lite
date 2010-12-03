package Class::Accessor::Lite;

use strict;

our $VERSION = '0.02';

use Carp ();

sub mk_new_and_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller(0);
    _mk_new($pkg, @properties);
    _mk_accessors($pkg, @properties);
}

sub mk_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller(0);
    _mk_accessors($pkg, @properties);
}

sub mk_ro_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller(0);
    _mk_ro_accessors($pkg, @properties);
}

sub mk_wo_accessors {
    (undef, my @properties) = @_;
    my $pkg = caller(0);
    _mk_wo_accessors($pkg, @properties);
}

sub _mk_new {
    my $pkg = shift;
    no strict 'refs';
    *{$pkg . '::new'} = __m_new(@_);
}

sub _mk_accessors {
    my $pkg = shift;
    no strict 'refs';
    for my $n (@_) {
        *{$pkg . '::' . $n} = __m($n);
    }
}

sub _mk_ro_accessors {
    my $pkg = shift;
    no strict 'refs';
    for my $n (@_) {
        *{$pkg . '::' . $n} = __m_ro($pkg, $n);
    }
}

sub _mk_wo_accessors {
    my $pkg = shift;
    no strict 'refs';
    for my $n (@_) {
        *{$pkg . '::' . $n} = __m_wo($pkg, $n);
    }
}

sub __m_new {
    my @props = @_;
    sub {
        my $klass = shift;
        bless {
            (map { $_ => undef } @props),
            (@_ == 1 && ref($_[0]) eq 'HASH' ? %{$_[0]} : @_),
        }, $klass;
    };
}

sub __m {
    my $n = shift;
    sub {
        return $_[0]->{$n} if @_ == 1;
        return $_[0]->{$n} = $_[1] if @_ == 2;
        shift->{$n} = \@_;
    };
}

sub __m_ro {
    my ($pkg, $n) = @_;
    sub {
        if (@_ == 1) {
            return $_[0]->{$n} if @_ == 1;
        } else {
            my $caller = caller(0);
            Carp::croak("'$caller' cannot access the value of '$n' on objects of class '$pkg'");
        }
    };
}

sub __m_wo {
    my ($pkg, $n) = @_;
    sub {
        if (@_ == 1) {
            my $caller = caller(0);
            Carp::croak( "'$caller' cannot alter the value of '$n' on objects of class '$pkg'")
        } else {
            return $_[0]->{$n} = $_[1] if @_ == 2;
            shift->{$n} = \@_;
        }
    };
}


1;

__END__

=head1 NAME

Class::Accessor::Lite - a minimalistic variant of Class::Accessor

=head1 SYNOPSIS

    package MyPackage;

    use Class::Accessor::Lite;

    # make accessors: "foo" and "bar"
    Class::Accessor::Lite->mk_accessors(qw(foo bar));

    # make read only accessors: "foo" and "bar"
    Class::Accessor::Lite->mk_ro_accessors(qw(foo bar));

    # make write only accessors: "foo" and "bar"
    Class::Accessor::Lite->mk_ro_accessors(qw(foo bar));

    # make accessors and the constructor
    Class::Accessor::Lite->mk_new_and_accessors(qw(foo bar));

=head1 DESCRIPTION

This is a minimalitic variant of C<Class::Accessor> and its alikes.

It is intended to be standalone and minimal, so that it can be copy & pasted into individual perl script files.

=head1 FUNCTIONS

=head2 Class::Accessor::Lite->mk_accessors(@name_of_the_properties)

Creates an accessor in current package under the name specified by the arguments that access the properties (of a hashref) with the same name.

=head2 Class::Accessor::Lite->mk_ro_accessors(@name_of_the_properties)

Same as mk_accessors() except it will generate read‐only accessors (ie
true accessors).  If you attempt to set a value with these accessors it
will throw an exception.

=head2 Class::Accessor::Lite->mk_wo_accessors(@name_of_the_properties)

Same as mk_accessors() except it will generate write‐only accessors
(ie. mutators).  If you attempt to read a value with these accessors it
will throw an exception.

=head2 Class::Accessor::Lite->mk_new_and_accessors(@name_of_the_properties)

Creates the C<new> function in addition to the accessors.  The function will accept a hash or a hashref as the initial properties of the object.  The default values of the properties are undef.

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

=head1 SEE ALSO

L<Class::Accessor>

L<Class::Accessor::Lite>

=head1 AUTHORS

Copyright (C) 2008 - 2010 Kazuho Oku

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.6 or, at your option, any later version of Perl 5 you may have available.

=cut

