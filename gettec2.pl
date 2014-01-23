#
use strict;
use warnings;

use DateTime;
use DBI;
use bs;

#my $date = DateTime->now;
my $date = DateTime->new ( year => 2014, month => 1, day => 23 );
my $today = $date->day() ."\.". $date->month() ."\.". $date->year();
my $todayZeroPad = sprintf ("%02d", $date->day()) ."\.". sprintf ("%02d", $date->month()) ."\.". $date->year();
my $todayZeroPadReverse = $date->year() . sprintf ("%02d", $date->month()) . sprintf ("%02d", $date->day());
print $todayZeroPad ."\n";

my $my_cnf = './gettec2.cnf';
my $dbh = DBI->connect("DBI:mysql:;" . "mysql_read_default_file=$my_cnf", undef, undef) or die "Cannot connect to MySQL server\n";

my $exchange = GetBSExchPage($todayZeroPadReverse);
print ExtractExchRate ($exchange, 'USD') ."\n";
print ExtractExchRate ($exchange, 'HRK') ."\n";
print ExtractExchRate ($exchange, 'MKD') ."\n";
print ExtractExchRate ($exchange, 'BAM') ."\n";
