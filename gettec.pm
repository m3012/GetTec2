package GetTec;

use strict;
use warnings;

use LWP::Simple;
use XML::Simple;
use DateTime::Format::DBI;
#use Data::Dumper;

BEGIN {
	require Exporter;
	# set the version for version checking
	our $VERSION     = 1.00;
	# Inherit from Exporter to export functions and variables
	our @ISA         = qw(Exporter);
	# Functions and variables which are exported by default
	our @EXPORT      = qw(GetExchRatePage ExtractExchRate InsertExchRate GetLJSETecPage ParseLJSETecPage GetZSETecPage ParseZSETecPage);
	# Functions and variables which can be optionally exported
	our @EXPORT_OK   = qw(GetExchRatePage ExtractExchRate GetZSETecPage ParseZSETecPage);
}


sub GetExchRatePage {
	my $dateZeroPadReverse = shift @_;

	my $url = 'http://www.nlb.si/?a=tecajnica&type=individuals&format=xml&date=' . $dateZeroPadReverse;
	my $xml = XML::Simple->new();
	my $data = $xml->XMLin(get($url));
	
	if ($data->{Date} eq $dateZeroPadReverse) {
		#print Dumper ($data->{rates}{Rate});
		return $data->{rates}{Rate};
	}
	print "ERROR: GetExchRatePage() could not retrieve exchange list!\n";
	return 0;
}

sub ExtractExchRate {
	my $content = shift @_;
	my $exchange = shift @_;
	
	my $value;
	foreach (@{$content}) {
		$value = $_;
		if ($value->{CCu} eq $exchange) {
			my $tmp = $value->{Sell};
			$tmp =~ s/\,/\./;
			return $tmp;
		}
	}
	print "ERROR: ExtractExchRate() could not extract exchange rate!\n";
	return 0;
}

sub InsertExchRate {
	my ($dbh, $date, $currency, $rate) = @_;
	
	my $db_parser = DateTime::Format::DBI->new($dbh);

	#check if date already exists
	my $sth = $dbh->prepare("SELECT * FROM gettec.exchange WHERE DATE(date)=? and currency=?");
	$sth->execute ($db_parser->format_datetime($date), $currency);
	my @row = $sth->fetchrow_array;
	if ($#row >= 0) { }
	else {
		#insert rate into table
		$dbh->do('INSERT INTO gettec.exchange (date, currency, value) VALUES (?, ?, ?)', undef, $db_parser->format_datetime($date), $currency, $rate);
	}
}

sub GetLJSETecPage {
	my $paper = shift @_;
	
	my $url = "http://www.ljse.si/cgi-bin/jve.cgi?SecurityID=$paper&doc=818";
	my $content = get($url);
	return $content if (defined $content);

	print "ERROR: GetLJSETecPage() could not retrieve exchange rates!\n";
	return 0;
}

sub ParseLJSETecPage {
	my $content = shift @_;
	
	$content =~ /<TR><TD vAlign=top>Teèaj<\/TD><TD vAlign=top align=right>(\d*\,\d*)<\/TD>/im;
	#            <TR><TD vAlign=top>Teèaj< /TD><TD vAlign=top align=right>4,180</TD></TR><TR>

	my $value = $1;
	$value =~ s/\,/\./;
	if ($value > 0) { return $value; }
	
	print "ERROR: ParseLJSETecPage() could not extract exchange rate!\n";
	return 0;
}


sub GetZSETecPage {
	my $paper = shift @_;
	
	my $url = "http://zse.hr/graf_data_dionice.aspx?dionice=$paper&datum=180";
	my $content = get($url);
	return $content if (defined $content);

	print "ERROR: GetZSETecPage() could not retrieve exchange rates!\n";
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
	
	print "ERROR: ParseZSETecPage() could not extract exchange rate!\n";
	return 0;
}

END { } 

1;