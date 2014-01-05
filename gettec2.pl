#
use strict;
use warnings;

use DateTime;
use DBI;
use bs;

#my $date = DateTime->now;
my $date = DateTime->new ( year => 2014, month => 1, day => 2 );
my $today = $date->day() ."\.". $date->month() ."\.". $date->year();
my $todayZeroPad = sprintf ("%02d", $date->day()) ."\.". sprintf ("%02d", $date->month()) ."\.". $date->year();
print $todayZeroPad ."\n";

my $host = '192.168.232.133';
my $database = "gettec";
my $port = 3306;
my $tablename = "exchange";
my $user = "gettec";
my $pw = "gettec123A";

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $pw) or die "Cannot connect to MySQL server\n";

my $exchange = GetBSExchPage();
print $exchange;
