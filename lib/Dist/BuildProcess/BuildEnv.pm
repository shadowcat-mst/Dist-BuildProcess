package Dist::BuildProcess::BuildEnv;

use Module::Metadata;
use CPAN::Meta::Requirements;
use File::Which qw(which);
use IPC::System::Simple qw(capturex);
use Mu::Tiny;

lazy env_vars => sub { \%ENV };

lazy extra_inc_dirs => sub { [] };

lazy core_inc_dirs => sub {
  my ($self) = @_;
  local %ENV;
  chomp(my @lines = capturex(
    $self->perl_binary, '-le', 'print for @INC'
  ));
  \@lines;
};

sub inc_dirs {
  my ($self) = @_;
  [ @{$self->core_inc_dirs}, @{$self->extra_inc_dirs} ];
}

lazy perl_binary => sub { $^X };

lazy make_binary => sub { which('gmake') || which('make') };

sub unsatisfied {
  my ($self, $reqs) = @_;
  grep {
    if ($_ eq 'perl') {
      my $ver = capturex($self->perl_binary, '-e', 'print $]');
      !($ver >= $reqs->requirements_for_module('perl'))
    } else {
      !$self->satisfies($_, $reqs)
    }
  } $reqs->required_modules;
}

sub satisfies {
  my ($self, $mod, $reqs) = @_;
  my $meta = Module::Metadata->new_from_module($mod, inc => $self->inc_dirs);
  return 0 unless $meta;
  return $reqs->accepts_module($mod, $meta->version);
}

1;
