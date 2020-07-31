use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

(do './maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

WriteMakefile(
  NAME => 'Dist::BuildProcess',
  VERSION_FROM => 'lib/Dist/BuildProcess.pm'
);
