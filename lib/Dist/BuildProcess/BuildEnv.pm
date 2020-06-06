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

lazy make_binary => sub { which('make') };

sub unsatisfied {
  my ($self, $reqs) = @_;
  grep {
    !$self->satisfies($_, $reqs->requirements_for_module($_))
  } $reqs->required_modules;
}

sub satisfies {
  my ($self, $mod, $want_ver) = @_;
  my $meta = Module::Metadata->new_from_module($mod, inc => $self->inc_dirs);
  return 0 unless $meta;
  $want_ver = '0' unless defined($want_ver) && length($want_ver);
  my $reqs = CPAN::Meta::Requirements->new;
  $reqs->add_string_requirement($mod, $want_ver);
  return $reqs->accepts_module($mod, $meta->version);
}

1;
