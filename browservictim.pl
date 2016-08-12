#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::Util qw(url_escape);

get '/' => sub {
    my $c = shift;
    my $refxss = url_escape '<iframe allowfullscreen=1 style="border:none;margin:0;width:100%;height:100%" src="http://www.stealthylabs.com">&nbsp;</iframe>';
    $c->render(template => 'index',
        refxss => "/userhome?user=$refxss",
    );
} => 'index';

get '/userhome.jsp' => sub {
    shift->redirect_to('userhome');
};

get '/userhome' => sub {
    my $c = shift;
    my $userid = $c->param('user');
    $c->render(text => "Your user id is $userid");
} => 'userhome';

    app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Browser Hacker Handbook practice framework!</h1>
To learn more, you can read the book.
<ul>
    <li><a href="<%= $refxss %>">Reflected XSS by injecting iframe</a></li>
</ul>


@@ userhome.html.ep
% layout 'default';
% title 'User Home';
Your user id is <%= $userid %>.

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
