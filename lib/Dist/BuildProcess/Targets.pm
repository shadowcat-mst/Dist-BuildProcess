package Dist::BuildProcess::Targets;

use strict;
use warnings;
use Exporter 'import';

use constant {
  INSTALL_SITE => \'site',
  INSTALL_VENDOR => \'vendor',
  INSTALL_CORE => \'core',
};

use Exporter 'import';

our @EXPORT_OK = qw(INSTALL_SITE INSTALL_VENDOR INSTALL_CORE);

our %EXPORT_TAGS = (installdirs => \@EXPORT_OK);

1;
