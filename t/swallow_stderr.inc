sub swallow_stderr {
	my ($code) = @_;

	open my $old_stderr, '>&', \*STDERR;
	close STDERR;
	open STDERR, '>', \(my $trashcan);

	$code->();

	close STDERR;
	open STDERR, '>&', $old_stderr;
}

1;
