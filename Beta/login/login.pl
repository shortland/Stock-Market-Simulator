#!/usr/bin/perl

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;

BEGIN
{
    $DB_SQL_username = "YellowFeather";
    $DB_SQL_password = "LegoApril181998!";

    $q = new CGI;
    $username = $q->param('username');
    $password = $q->param('password');

    sub logger #logger('>'.__LINE__.'<');
    {
        my ($line) = @_;
        print $line;
    }

    if(defined $username)
    {
        if(length($username) < 3)
        {
            print "Content-Type: text/html\n\n";
            print "Invalid username";
            exit;
        }
        if(length($password) < 3)
        {
            print "Content-Type: text/html\n\n";
            print "Invalid password";
            exit;
        }
        my $dbh_random123164 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost", $DB_SQL_username, $DB_SQL_password, 
            {'RaiseError' => 1});

        my $sth_random123164 = $dbh_random123164->prepare("SELECT password, u_cookie, p_cookie FROM users WHERE username = ?");

        $sth_random123164->execute($username) or die "Couldn't execute statement: $DBI::errstr; stopped";

        while(my($dbg_password, $dbg_u_cookie, $dbg_p_cookie) = $sth_random123164->fetchrow_array())
        {
            $users_real_password = $dbg_password;
            $u_cookie = $dbg_u_cookie;
            $p_cookie = $dbg_p_cookie;
        }
        $dbh_random123164->disconnect();

        if($users_real_password =~ /^($password)$/)
        {
            my $u_cookie_setter = CGI::Cookie->new(-name => 'u_cookie', -value => $u_cookie, -expires => '+3M');
            my $p_cookie_setter = CGI::Cookie->new(-name => 'p_cookie', -value => $p_cookie, -expires => '+3M');
            print "Set-Cookie: $u_cookie_setter\n";
            print "Set-Cookie: $p_cookie_setter\n";
            print "Location: ../portfolio.pl\n\n";
        }
        else
        {
            print "Username or password is incorrect.";
        }
    }
    else
    {
        print "Content-Type: text/html\n\n";
        print qq
        {
            <!DOCTYPE HTML>
            <html>
            <head>
                <title>Login</title>
            </head>
            <body>
                <p>Login</p>
                <form method='POST' action='login.pl'>
                    <p>Username: <input type='text' name='username'></p>
                    <p>Password: <input type='password' name='password'></p>
                    <input type='submit' value='Login'>
                </form>
            </body>
            </html>
        };
    }
    open(STDERR, ">&STDOUT");
}