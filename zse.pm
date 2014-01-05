package zse;

use strict;
use warnings;

use LWP::Simple;


BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.00;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(GetZSETecPage ParseZSETecPage);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw(GetZSETecPage ParseZSETecPage);
}


sub GetZSETecPage {
	my $paper = shift @_;
	
	my $url = "http://zse.hr/graf_data_dionice.aspx?dionice=$paper&datum=180";
	my $content = get($url);
	return $content if (defined $content);

	return 0;
}

sub ParseZSETecPage {
	my $date = shift @_;
	my $content = shift @_;
	
	# date values are separated by "--++--" pattern
	my @valuesByDate = split ('--\+\+--', $content);
	foreach (@valuesByDate) {
		#individual values within a date are split with "-+-" pattern
		my @values = split ('-\+-', $content);
		
		if ($values[0] eq $date) { return $values[4]; }
	}
	
	return 0;
}

END { } 

1;