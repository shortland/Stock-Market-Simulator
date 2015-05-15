#!/usr/bin/perl

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use DBI;
use CGI::Cookie;

BEGIN
{
    $DB_SQL_username = "username";
    $DB_SQL_password = "password";

    $q = new CGI;
    $method = $q->param('method');

    %cookies = CGI::Cookie->fetch;

    if(!defined $cookies{'u_cookie'})
    {
        print $q->header(-Location=>'login/login.pl');
    }
    if(!defined $cookies{'p_cookie'})
    {
        print $q->header(-Location=>'login/login.pl');
    }
    else
    {
        $got_u_cookie = $cookies{'u_cookie'}->value;
        $got_p_cookie = $cookies{'p_cookie'}->value;

        my $dbh_random123164 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost", "$DB_SQL_username", "$DB_SQL_password",
        {'RaiseError' => 1});

        my $sth_random123164 = $dbh_random123164->prepare("SELECT u_cookie, p_cookie, username FROM users WHERE u_cookie = ? AND p_cookie = ?");
        $sth_random123164->execute($got_u_cookie, $got_p_cookie) or die "Couldn't execute statement: $DBI::errstr; stopped";
        
        while(my($u_cookie, $p_cookie, $username, $email, $user_valid) = $sth_random123164->fetchrow_array())
        {
            $real_username = $username;
            $real_email = $email;
            $real_access = $user_valid;
            $valida = "ok";
        }
        $dbh_random123164->disconnect();

        if($valida !~ "ok")
        {
            print $q->header(-Location=>'login/login.pl');
        }
        if(!defined $valida)
        {
            print $q->header(-Location=>'login/login.pl');
        }
    }
    print "Content-Type: text/html\n\n";
    open(STDERR, ">&STDOUT");
}
1;


