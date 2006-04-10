package B::Lint::StrictOO;

use warnings;
use strict;

=head1 NAME

B::Lint::StrictOO - Apply strict to classes and methods

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

Validates that classes exist, that methods that are called on classes
and objects, and variables aren't used as method names.

  $ perl -MB::Lint::StrictOO -MO=Lint,oo my_file.pl

  sub Hickory::Dickory::dock;

  Mouse->dockk;           # Class Mouse doesn't exist
  Hickory::Dickory->dock;
  Hickory::Dickory->$_;   # Symbolic method call
  $obj->dockk;            # Object can't do method
  $obj->dock;
  $obj->$_;               # Symbolic method call

=head1 PRIVATE FUNCTIONS

=head2 match

See B::Lint's plugin documentation.

=cut

use B::Lint;
B::Lint->register_plugin( __PACKAGE__, [ 'oo' ] );

sub match
{
    my ( $op, $check ) = @_;

    if ( $check->{oo} and $op->name() eq 'entersub' )
    {
        my $class  = eval { $op->first->sibling         ->sv->PV };
        my $method = eval { $op->first->sibling->sibling->sv->PV };

        if ( defined $class )
        {
            no strict 'refs';

            # check strict classes
            if ( not defined %{ $class . '::' } )
            {
                B::Lint::warning "Class $class doesn't exist";
            }
            # check strict class methods
            elsif ( defined $method and not $class->can($method) )
            {
                B::Lint::warning "Class $class can't do method $method";
            }
            elsif ( not defined $method )
	    {
                B::Lint::warning "Symbolic method call";
            }
        }
        elsif (     defined $method
                and not grep { $_->can($method) } classes( B::Lint->file() ) )
        {
            B::Lint::warning "Object can't do method $method";
        }
        elsif ( not defined $method )
	{
            B::Lint::warning "Symbolic method call";
	}
    }
}

=head2 @classes = classes( file name )

=cut

use File::Slurp 'read_file';
my %classes;
sub classes
{
    my $file = shift;
    no strict 'refs';
    $classes{$file} ||= scalar {
        map { $_ => 1 }
        grep { %{ $_ . '::' } }
        read_file($file) =~ m/( \w+ (?: (?:::|')\w+ )* )/msxg
    };
    return keys %{ $classes{$file} };
}

=head1 AUTHOR

Joshua ben Jore, C<< <jjore at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-b-lint-strictoo at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=B-Lint-StrictOO>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc B::Lint::StrictOO

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/B-Lint-StrictOO>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/B-Lint-StrictOO>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=B-Lint-StrictOO>

=item * Search CPAN

L<http://search.cpan.org/dist/B-Lint-StrictOO>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Joshua ben Jore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
