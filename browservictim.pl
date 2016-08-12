#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::Util qw(url_escape);

get '/' => sub {
    my $c = shift;
    my $refxss1 = url_escape '<iframe allowfullscreen=1 style="border:none;margin:0;width:100%;height:100%" src="http://www.stealthylabs.com">&nbsp;</iframe>';
    my $refxss2 = url_escape q{<script type="text/javascript">alert('You are a browser victim!');</script>};
    $c->render(template => 'index',
        refxss1 => "/userhome.jsp?user=$refxss1",
        refxss2 => "/userhome.jsp?user=$refxss2",
    );
} => 'index';

get '/userhome.jsp' => sub {
    my $c = shift;
    my $userid = $c->param('user');
    $c->render(text => "Your user id is $userid");
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Browser Hacker Handbook practice framework!</h1>
To learn more, you can read the book.
<ul>
    <li><a href="<%= $refxss1 %>">Reflected XSS by injecting iframe</a></li>
    <li><a href="<%= $refxss2 %>">Reflected XSS by injecting javascript</a></li>
</ul>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
