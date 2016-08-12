use Test::More;
use Test::Mojo;
use Mojo::Util qw(url_escape);

use FindBin;
require "$FindBin::Bin/../browservictim.pl";


my $t = Test::Mojo->new;
$t->ua->max_redirects(10);
$t->get_ok('/')->status_is(200)->content_like(qr/Browser Hacker Handbook/);

$t->get_ok($t->app->url_for('/userhome.jsp'), form => {
        user => '<strong>browserhackerhandbook</strong>'})->status_is(200)
        ->element_exists('strong')->content_like(qr/browserhackerhandbook/);

$t->get_ok($t->app->url_for('/userhome.jsp'), form => {
        user => '<script>alert("browser victim");</script>'})->status_is(200)
        ->element_exists('script')->content_like(qr/browser victim/);

$t->get_ok($t->app->url_for('/newuser.jsp'), form => {
    userdisplayname => '<script>alert("browser victim");</script>',
    })->status_is(200)->element_exists(a => qr/Add New User/)
    ->element_exists(script => qr/browser victim/);

done_testing();
