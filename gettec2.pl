#!/usr/bin/perl

use strict;
use warnings;

use DateTime;
use DBI;
use GetTec;

my $date;
if ($#ARGV >= 0) {
	$ARGV[0] =~ /(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})/;
	$date = DateTime->new ( year => $+{year}, month => $+{month}, day => $+{day} );
}
else {
	$date = DateTime->now;
}

my $today = $date->day() ."\.". $date->month() ."\.". $date->year();
my $todayZeroPad = sprintf ("%02d", $date->day()) ."\.". sprintf ("%02d", $date->month()) ."\.". $date->year();
my $todayZeroPadReverse = $date->year() . sprintf ("%02d", $date->month()) . sprintf ("%02d", $date->day());
print 'Retrieveing exchanges for: ' . $todayZeroPad ."\n";

my $my_cnf = './gettec2.cnf';
my $dbh = DBI->connect("DBI:mysql:;" . "mysql_read_default_file=$my_cnf", undef, undef) or die "Cannot connect to MySQL server\n";

my $exchange = GetExchRatePage($todayZeroPadReverse);

# get currencies
my $rate;
my $sth = $dbh->prepare("SELECT * FROM gettec.currency;");
$sth->execute ();
while (my ($currency) = $sth->fetchrow_array) {
	# get exchange rate
	$rate = ExtractExchRate ($exchange, $currency);

	# insert rate into db
	InsertExchRate ($dbh, $date, $currency, $rate);
}

$dbh->disconnect;