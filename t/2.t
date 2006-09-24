#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 7;
use ExtUtils::PkgConfig;

$ENV{PKG_CONFIG_PATH} = './t/';

my @cmds = qw(modversion libs cflags libs_only_L libs_only_l);
my $data;

foreach my $cmd (@cmds) {
	$data = ExtUtils::PkgConfig->$cmd(qw/test_glib-2.0/);
	ok( defined $data );
}

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
