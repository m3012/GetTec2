package zse;

use strict;
use warnings;

use LWP::Simple;

sub GetTecPage {
	my $paper = shift @_;
	
	my $url = "http://zse.hr/graf_data_dionice.aspx?dionice=$paper&datum=180";
	my $content = get($url);
	return $content if (defined $content);

	return "";
}

sub ParseTecPage {
	my $date = shift @_;
	my $content = shift @_;
	
	# date values are separated by "--++--" pattern
	my @valuesByDate = split ('--\+\+--', $content);
	foreach (@valuesByDate) {
		#individual values within a date are split with "-+-" pattern
		my @values = split ('-\+-', $content);
		
		if ($values[0] eq $date) { return $values[4]; }
	}
	
	return "error";
}

1;