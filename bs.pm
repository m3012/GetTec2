#!perl

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request::Common;

BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.00;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(GetBSExchPage);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw(GetBSExchPage);
}

sub GetBSExchPage {
	my $dateZeroPad = shift @_;

	my $ua = LWP::UserAgent->new;
	my $response = $ua->request(POST 'http://www.bsi.si/podatki/tec-BS.asp', [dat => $dateZeroPad]);
	if ($response->is_success) {
		my $content = $response->content;
		my $searchString = "Te.ajna lista z dne " . $dateZeroPad;
		if ($content =~ m/$searchString/) { 
			return $content;
		}
		else {
			return 0;
		}
	}
	else {
		#print STDERR $response->status_line, "\n";
		return 0;
	}
}

END { } 

1;