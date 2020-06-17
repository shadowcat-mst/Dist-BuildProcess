package Dist::BuildProcess::Driver::MM;

use Mu::Tiny;

extends 'Dist::BuildProcess::Driver';

sub _configure_file { 'Makefile.PL' }

sub _phase_command { $_[0]->make_binary }

sub _format_argpair { uc($_[1]).'='.$_[2] }

1;
