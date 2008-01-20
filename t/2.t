#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 11;
use ExtUtils::PkgConfig;

$ENV{PKG_CONFIG_PATH} = './t/';

my @cmds = qw(libs
              modversion
              cflags
              cflags-only-I
              cflags-only-other
              libs-only-L
              libs-only-l
              libs-only-other);
my $data;

foreach my $cmd (@cmds) {
	$data = ExtUtils::PkgConfig->$cmd(qw/test_glib-2.0/);
	ok( defined $data );
}

# special case
$data = ExtUtils::PkgConfig->static_libs(qw/test_glib-2.0/);
like ($data, qr/pthread/);

$data = ExtUtils::PkgConfig->variable(qw/test_glib-2.0/, 'glib_genmarshal');
ok( defined $data );

$data = ExtUtils::PkgConfig->variable(qw/test_glib-2.0/, '__bad__');
ok( not defined $data );

# Calling these with invalid packages is not supported.
# foreach my $cmd (@cmds) {
# 	eval { $data = ExtUtils::PkgConfig->$cmd(qw/__bad__/); };
# 	ok( $@ );
# }

# eval { $data = ExtUtils::PkgConfig->variable(qw/__bad__/, 'glib_genmarshal'); };
# ok( $@ );
