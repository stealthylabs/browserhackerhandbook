use Test::More;
use Test::Mojo;
use Mojo::Util qw(url_escape);

use FindBin;
require "$FindBin::Bin/../browservictim.pl";


my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_like(qr/Browser Hacker Handbook/);

$t->get_ok('/userhome.jsp')->status_is(302);

my $rxss = url_escape '<strong>browserhackerhandbook</strong>';
$t->get_ok("/userhome?user=$rxss")->status_is(200)->element_exists('strong');


done_testing();
