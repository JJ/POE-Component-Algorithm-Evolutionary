package POE::Component::Algorithm::Evolutionary;

use lib qw( ../../../../../Algorithm-Evolutionary/lib ); #For development and perl syntax mode

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.3');

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;

use POE;
use Algorithm::Evolutionary;

# Module implementation here
sub new {
  my $class = shift;
  my %args = @_;

  my $fitness = delete $args{Fitness} || croak "Fitness required";
  my $creator = delete $args{Creator} || croak "Creator required";
  my $single_step = delete $args{Single_Step} || croak "Single_Step required";
  my $terminator = delete $args{Terminator} || croak "Terminator required";
  my $alias = delete $args{Alias} || croak "Alias required";

  my $self = { alias => $alias };
  bless $self, $class;

  my $session = POE::Session->create(inline_states => { _start => \&start,
						      generation => \&generation,
						      finish => \&finishing},
				     args  => [$alias, $creator, $single_step, 
					       $terminator, $fitness, $self]
				    );
  $self->{'session'} = $session;
  return $self;
}

sub start {
  my ($kernel, $heap, $alias, $creator, 
      $single_step, $terminator, $fitness,$self )= 
	@_[KERNEL, HEAP, ARG0, ARG1, ARG2, ARG3, ARG4, ARG5];
  $kernel->alias_set($alias);
  $heap->{'single_step'} = $single_step;
  $heap->{'terminator' } = $terminator;
  $heap->{'creator' } = $creator;
  $heap->{'fitness' } = $fitness;
  $heap->{'self'} = $self;
  my @pop;
  $creator->apply( \@pop );
  map( $_->evaluate($fitness), @pop );
  $heap->{'population'} = \@pop;
  $kernel->yield('generation');
}

sub generation {
  my ($kernel, $heap ) = @_[KERNEL, HEAP];
  $heap->{'single_step'}->apply( $heap->{'population'} );
  if ( ! $heap->{'terminator'}->apply( $heap->{'population'} ) ) {
    $kernel->yield( 'finish' );
  } else {
    $kernel->yield( 'generation' );
  }

}

sub finishing {
  my ($kernel, $heap ) = @_[KERNEL, HEAP];
  print "Best is:\n\t ",$heap->{'population'}->[0]->asString()," Fitness: ",
    $heap->{'population'}->[0]->Fitness(),"\n";
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Poe::Component::Algorithm::Evolutionary - Run evolutionary algorithms in a preemptive multitasking way.


=head1 VERSION

This document describes Poe::Component::Algorithm::Evolutionary version 0.0.3


=head1 SYNOPSIS

    use Poe::Component::Algorithm::Evolutionary;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Poe::Component::Algorithm::Evolutionary requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-poe-component-algorithm-evolutionary@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>

=begin html 

Boilerplate taken from <a
href='http://perl.com/pub/a/2004/07/22/poe.html?page=2'>article in
perl.com</a> 

=end html


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
