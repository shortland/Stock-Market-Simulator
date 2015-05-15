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
    $email = $q->param('email');

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
            print "Please input a username with more than 3 characters";
            exit;
        }
        if(length($password) < 3)
        {
            print "Content-Type: text/html\n\n";
            print "Please input a password with more than 3 characters";
            exit;
        }
        if(length($email) < 4)
        {
            print "Content-Type: text/html\n\n";
            print "Please input a valid email";
            exit;
        }
        my $dbh_random123164 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost", $DB_SQL_username, $DB_SQL_password, 
            {'RaiseError' => 1});

        my $sth_random123164 = $dbh_random123164->prepare("SELECT password FROM users WHERE username = ?");

        $sth_random123164->execute($username) or die "Couldn't execute statement: $DBI::errstr; stopped";

        while(my($dbg_password) = $sth_random123164->fetchrow_array())
        {
            if(length($dbg_password) > 2)
            {
                print "Content-Type: text/html\n\n";
                print "Username is taken\n";
                exit;
                $valid = "no";
            }
        }
        $dbh_random123164->disconnect();

        if($valid !~ /^(no)$/)
        {
            my @chars = ("A".."Z", "a".."z", "0".."9");
            my $u_cookie;
            $u_cookie .= $chars[rand @chars] for 1..16;
            my $p_cookie;
            $p_cookie .= $chars[rand @chars] for 1..16;

            my $sth_random1231641 = $dbh_random123164->prepare("INSERT INTO users (username, password, email, u_cookie, p_cookie) VALUES (?, ?, ?, ?, ?)");
    
            $sth_random1231641->execute($username, $password, $email, $u_cookie, $p_cookie) or die "Couldn't execute statement: $DBI::errstr; stopped";
            
            my $u_cookie_setter = CGI::Cookie->new(-name => 'u_cookie', -value => $u_cookie, -expires => '+3M');
            my $p_cookie_setter = CGI::Cookie->new(-name => 'p_cookie', -value => $p_cookie, -expires => '+3M');
            print "Set-Cookie: $u_cookie_setter\n";
            print "Set-Cookie: $p_cookie_setter\n";

            #print "Content-Type: text/html\n\n";
            print "Location: ../portfolio.pl\n\n";
            print "Registration successful. Logging in...";

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
                <title>Register</title>
            </head>
            <body>
                <p>Register</p>
                <form method='POST' action='register.pl'>
                    <p>Username: <input type='text' name='username'></p>
                    <p>Email: <input type='email' name='email'></p>
                    <p>Password: <input type='password' name='password'></p>
                    <input type='submit' value='Register'>
                </form>
            </body>
            </html>
        };
    }
    open(STDERR, ">&STDOUT");
}