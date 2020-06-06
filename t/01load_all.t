use strict;
use warnings;
use Path::Tiny;
use Test::More;

my $lib = path('lib');

$lib->visit(sub {
  my ($path) = @_;
  return unless /\.pm$/;
  $path =~ s{^lib/}{};
  require $path;
  pass "Required $path";
}, { recurse => 1 });

pass "Completed load_all test";

done_testing;
