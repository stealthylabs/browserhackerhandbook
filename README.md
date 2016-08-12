# The Browser Hacker Handbook

This repository holds source code for buyers of the Browser Hacker Handbook to
practice their skills because the book's actual test URLs **do not** work as of
August 10, 2016 which is the starting date of this repository.

## COPYRIGHT

&copy; 2016. Stealthy Labs LLC. All Rights Reserved.

## LICENSE

Software in this repository is licensed as the GNU Affero General Public License version 3.


## INSTALLATION

You need to have perl 5.14 or better installed. If you use a more recent
distribution, you will have that already. Check your version using the following
command:

    $ perl -V


You need to have `cpanminus` installed. In your distributions like Debian or
Ubuntu it should be available as the `cpanminus` package.

    $ sudo apt-get install cpanminus
    $ which cpanm
    /usr/bin/cpanm


Or if you do not have that, then you can use `cpan` to install it.

    $ sudo cpan -i App::cpanminus
    $ which cpanm
    /usr/local/bin/cpanm

Install the dependencies first.


    $ cpanm --installdeps .






