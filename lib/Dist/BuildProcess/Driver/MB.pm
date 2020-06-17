package Dist::BuildProcess::Driver::MB;

use Mu::Tiny;

extends 'Dist::BuildProcess::Driver';

sub _configure_file { 'Build.PL' }

sub _phase_command { ($_[0]->perl_binary, 'Build') }

sub _format_argpair { '--'.lc($_[1]).'='.$_[2] }

1;
