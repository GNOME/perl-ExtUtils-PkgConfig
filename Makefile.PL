use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'dist' => {
           PREOP    => 'pod2text lib/ExtUtils/PkgConfig.pm | tee README >$(DISTVNAME)/README; chmod -R u=rwX,go=rX . ;',
           COMPRESS => 'gzip -9v',
           SUFFIX   => '.gz',
    },
    'NAME' => 'ExtUtils::PkgConfig',
    'VERSION_FROM' => 'lib/ExtUtils/PkgConfig.pm',
);

package MY;
use Cwd;
sub postamble
{
	my @dirs = qw{rpms rpms/BUILD rpms/RPMS rpms/SOURCES
		      rpms/SPECS rpms/SRPMS};
	my $cwd = getcwd();

	my %subs = (
		'VERSION' => '$(VERSION)',
		'SOURCE' => '$(DISTNAME)-$(VERSION).tar.gz',
	);
	
	my $substitute = '$(PERL) -npe \''.join('; ', map {
			"s/\\\@$_\\\@/$subs{$_}/g";
		} keys %subs).'\'';

"
realclean ::
	-\$(RM_F) perl-\$(DISTNAME).spec
	
rpms/:
	-mkdir @dirs

SUBSTITUTE=$substitute

perl-\$(DISTNAME).spec: perl-\$(DISTNAME).spec.in \$(VERSION_FROM) Makefile
	\$(SUBSTITUTE) \$< > \$@

dist-rpms: Makefile dist perl-\$(DISTNAME).spec rpms/
	cp \$(DISTNAME)-\$(VERSION).tar.gz rpms/SOURCES/
	rpmbuild -ba --define \"_topdir $cwd/rpms\" perl-\$(DISTNAME).spec
"
}
package MAIN;
