requires 'Mojolicious', '7.0';
requires 'JSON::PP';
recommends 'JSON::MaybeXS';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Mojo';
};

on 'develop' => sub {
    recommends 'Devel::NYTProf';
};
