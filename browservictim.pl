#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::Util qw(url_escape);
use Mojo::SQLite;

app->secrets(['browser hacker handbook']);

helper sqlite => sub {
    state $sql = Mojo::SQLite->new('sqlite:bhh.db');
};

app->sqlite->migrations->from_data->migrate;

get '/' => sub {
    my $c = shift;
    my $refxss1 = url_escape q{<iframe allowfullscreen=1 style="border:none;margin:0;width:100%;height:100%" src="http://www.stealthylabs.com">&nbsp;</iframe>};
    my $refxss2 = url_escape q{<script type="text/javascript">alert('You are a browser victim!');</script>};
    $c->render(template => 'index',
        refxss1 => "/userhome.jsp?user=$refxss1",
        refxss2 => "/userhome.jsp?user=$refxss2",
        permxss1 => "/newuser.jsp?userdisplayname=" . url_escape q{<script>alert('browser victim');</script>},
    );
} => 'index';

get '/userhome.jsp' => sub {
    shift->render;
} => 'userhome';

get '/newuser.jsp' => sub {
    my $c = shift;
    my $userdn = $c->param('userdisplayname');
    return $c->render unless $userdn;
    unless ($c->session('user')) {
        my $uid = $c->sqlite->db->query(q{INSERT INTO users(displayname) VALUES(?)}, $userdn)->last_insert_id;
        $c->session(user => $uid, expiration => 86400);
    } else {
        my $uid = $c->session('user');
        $c->sqlite->db->query(q{UPDATE users SET displayname = ? WHERE id = ? }, $userdn, $uid);
    }
    $c->redirect_to('/listusers.jsp');
} => 'newuser';
get '/listusers.jsp' => sub {
    my $c = shift;
    my $users = $c->sqlite->db->query(q{SELECT * FROM users LIMIT 10})->hashes->to_array;
    $c->render(users => $users);
} => 'listusers';

app->start;
__DATA__
@@ migrations
-- 1 up
CREATE TABLE users(id INTEGER PRIMARY KEY, displayname TEXT);
-- 1 down
DROP TABLE users;


@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Browser Hacker Handbook practice framework!</h1>
To learn more, you can read the book.
<ul>
    <li><a href="<%== $refxss1 %>">Reflected XSS by injecting iframe</a></li>
    <li><a href="<%== $refxss2 %>">Reflected XSS by injecting javascript</a></li>
    <li><a href="<%== $permxss1 %>">Stored XSS example by injecting javascript</a></li>
</ul>

@@ userhome.html.ep
% layout 'default';
% title 'User Home';
%= tag p => begin
    Your user id is <%== param('user') %>
%end

@@ listusers.html.ep
% layout 'default';
% title 'List Users';
% foreach my $h (@$users) {
    %= tag p => begin
        User:  <%== $h->{displayname} %>
    %end
    %= tag 'br'
%}
%= link_to 'Add New User' => 'newuser'

@@ newuser.html.ep
% layout 'default';
% title 'New User';
%= form_for newuser => begin
    %= label_for 'displayname' => 'User Name'
    %= text_field 'displayname'
    %= submit_button
% end

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
