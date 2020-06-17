package Dist::BuildProcess::CommandPhase;

use CPAN::Meta::Requirements;
use IPC::System::Simple qw(systemx);
use File::chdir;
use Mu::Tiny;

ro 'name';
ro 'command';
ro 'build_process';

sub build_env { shift->build_process->build_env }

sub quoted_command {
  my ($self) = @_;
  require String::ShellQuote;
  return String::ShellQuote(@{$self->command});
}

sub run_command {
  my ($self) = @_;
  my $be = $self->build_env;
  local %ENV = %{$be->env_vars};
  $ENV{PERL5LIB} = join(':', $ENV{PERL5LIB}//(), @{$be->extra_inc_dirs});
  $ENV{PERL_MM_USE_DEFAULT} = 1 unless $self->build_process->interactive;
  local $CWD = $self->build_process->build_dir;
  systemx(@{$self->command});
}

1;
