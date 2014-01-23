#!perl

use strict;
use warnings;

use LWP::Simple;
use XML::Simple;
use Data::Dumper;

BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.00;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(GetBSExchPage ExtractExchRate);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw(GetBSExchPage ExtractExchRate);
}

sub GetBSExchPage {
	my $dateZeroPadReverse = shift @_;

	#my $url = 'http://www.bsi.si/_data/tecajnice/dtecbs-l.xml';
	#my $url = 'http://www.bsi.si/_data/tecajnice/dtecbs.xml';
	my $url = 'http://www.nlb.si/?a=tecajnica&type=individuals&format=xml&date=20140123';
	
	my $xml = XML::Simple->new();
	
	my $data = $xml->XMLin(get($url));
	
	if ($data->{Date} eq $dateZeroPadReverse) {
		return $data->{rates}{Rate};
	}
	return 0;
}


sub ExtractExchRate {
	my $content = shift @_;
	my $exchange = shift @_;
	my $value;
	
	foreach (@{$content}) {
		$value = $_;
		if ($value->{CCu} eq $exchange) { return $value->{Sell}; }
	}
	return 0;
}

END { } 

1;