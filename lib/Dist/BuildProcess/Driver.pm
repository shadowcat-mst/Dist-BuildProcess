package Dist::BuildProcess::Driver;

use File::chdir;
use CPAN::Meta;
use Carp ();
use Dist::BuildProcess::CommandPhase;
use Mu::Tiny;

ro 'build_process';

sub build_env { shift->build_process->build_env }

sub perl_binary { shift->build_env->perl_binary }
sub make_binary { shift->build_env->make_binary }

sub configure_phase {
  my $self = shift;
  my $bp = $self->build_process;
  $self->_command_phase(
    configure =>
      ($self->perl_binary,
       $self->_configure_file,
       $bp->install_target//(),
       (map +($_ ? [destdir => $_] : ()), $bp->destdir),
       @_,
      )
  );
}

sub build_phase { shift->_phase('build', undef, @_) }
sub test_phase { shift->_phase('test', 'test', @_) }
sub install_phase { shift->_phase('install', 'install', @_) }

sub _phase {
  my ($self, $name, $subcommand, @args) = @_;
  $self->_command_phase(
    $name =>
      ($self->_phase_command, $subcommand//()),
      @args,
  );
}

sub _command_phase {
  my ($self, $name, @command) = @_;
  Dist::BuildProcess::CommandPhase->new(
    name => $name,
    command => [ map { ref() ? $self->_format_argpair(@$_) : $_ } @command ],
    build_process => $self->build_process,
  );
}

sub develop_deps { shift->_deps_for('develop', { sloppy => 1, @_ }) }
sub configure_deps { shift->_deps_for('configure', { sloppy => 1, @_ }) }
sub build_deps { shift->_deps_for(qw(configure runtime build), {@_}) }
sub test_deps { shift->_deps_for(qw(configure runtime build test), {@_}) }
sub install_deps { shift->_deps_for(qw(configure runtime build), {@_}) }
sub runtime_deps { shift->_deps_for('runtime', {@_}) }

sub _metafile {
  my ($self, $name) = @_;
  return $_ for grep -f $_, "${name}.json", "${name}.yml";
  return;
}

sub _deps_for {
  my ($self, @phases) = @_;
  my $opt = pop @phases;
  local $CWD = $self->build_process->build_dir;
  my $file = $self->_metafile('MYMETA');
  unless ($file) {
    Carp::croak "No MYMETA file in $CWD" unless $opt->{sloppy};
    $file = $self->_metafile('META');
    Carp::croak "No META or MYMETA file in $CWD" unless $file;
  }
  my $meta = CPAN::Meta->load_file($file);
  my $types = $opt->{types}||['requires']; # BuildPolicy ?
  return $meta->effective_prereqs->requirements_for(\@phases,$types);
}

1;
