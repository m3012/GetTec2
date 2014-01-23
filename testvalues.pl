#!perl

use strict;
use warnings;
use DBI;

my $host = '192.168.232.133';
my $database = "gettec";
my $port = 3306;
my $tablename = "exchange";
my $user = "gettec";
my $pw = "gettec123A";

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $pw) or die "Cannot connect to MySQL server\n";