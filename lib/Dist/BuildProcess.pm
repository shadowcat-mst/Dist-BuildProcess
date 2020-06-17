package Dist::BuildProcess;

use strict;
use warnings;

our $VERSION = '0.000001'; # 0.0.1

$VERSION = eval $VERSION;

use Carp ();
use File::chdir;
use Mu::Tiny;

ro 'build_env';
ro 'build_dir';
ro 'install_target';
lazy destdir => sub { undef };
lazy interactive => sub { 0 };

lazy driver_class => sub {
  my ($self) = @_;
  local $CWD = $self->build_dir;
  if (-f 'Makefile.PL') {
    return '+MM';
  } elsif (-f 'Build.PL') {
    return '+MB';
  }
  Carp::croak "Unable to determine driver type for $CWD";
};

lazy driver => sub {
  my ($self) = @_;
  my $driver_class = do {
    (my $type = $self->driver_class) =~ s/^\+/Dist::BuildProcess::Driver::/;
    $type;
  };
  require join('/', split '::', $driver_class).".pm";
  return $driver_class->new(%$self);
};

sub develop_deps { shift->driver->develop_deps(@_) }
sub configure_deps { shift->driver->configure_deps(@_) }
sub build_deps { shift->driver->build_deps(@_) }
sub test_deps { shift->driver->test_deps(@_) }
sub install_deps { shift->driver->install_deps(@_) }
sub runtime_deps { shift->driver->runtime_deps(@_) }

sub configure_phase { shift->driver->configure_phase(@_) }
sub build_phase { shift->driver->build_phase(@_) }
sub test_phase { shift->driver->test_phase(@_) }
sub install_phase { shift->driver->install_phase(@_) }

1;

=head1 NAME

Dist::BuildProcess - Description goes here

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

 mst - Matt S. Trout (cpan:MSTROUT) <mst@shadowcat.co.uk>

=head1 CONTRIBUTORS

None yet - maybe this software is perfect! (ahahahahahahahahaha)

=head1 COPYRIGHT

Copyright (c) 2020 the Dist::BuildProcess L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.
