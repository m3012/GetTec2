#
use strict;
use warnings;

use LWP::Simple;
use DateTime;

my $date = DateTime->now;
$today = $date->day() ."\.". $date->month() ."\.". $date->year();

$url = "http://zse.hr/graf_data_dionice.aspx?dionice=HT-R-A&datum=180";
$content = get($url);
die "Can't GET $url" if (! defined $content);

print $content;
print "\n\n";



my @valuesByDate = split ('--++--', $content);
foreach (@valuesByDate) {
	
}
