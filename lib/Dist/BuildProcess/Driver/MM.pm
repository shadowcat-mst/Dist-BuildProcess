package Dist::BuildProcess::Driver::MM;

use Mu::Tiny;

extends 'Dist::BuildProcess::Driver';

sub _configure_file { 'Makefile.PL' }

sub _phase_command { $_[0]->make_binary }

sub _format_args {
  my ($self, @argpairs) = @_;
  map uc($_->[0]).'='.$_->[1], @argpairs;
}

1;
