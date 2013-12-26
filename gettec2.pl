#
use strict;
use warnings;

#use Perl::Unit;
use LWP::Simple;
use Time::Piece;

my $date = Time::Piece->new->strftime('%m/%d/%Y');
$url = "http://zse.hr/graf_data_dionice.aspx?dionice=HT-R-A&datum=180";
$content = get($url);
die "Can't GET $url" if (! defined $content);

print $content;
print "\n\n";

$today = Time::Piece->new->strftime('%d.%m.%Y'); 
print 'Date: '. $today;


my @valuesByDate = split ('--++--', $content);
foreach (@valuesByDate) {
	
}


#$value =~ $content
