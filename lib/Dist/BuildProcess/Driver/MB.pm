package Dist::BuildProcess::Driver::MB;

use Mu::Tiny;

extends 'Dist::BuildProcess::Driver';

sub _configure_file { 'Build.PL' }

sub _phase_command { ($_[0]->perl_binary, 'Build') }

sub _format_args {
  my ($self, @argpairs) = @_;
  map '--'.join('-', split '_', $_->[0]).'='.$_->[1], @argpairs;
}

1;
