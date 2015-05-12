#!/usr/bin/perl

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;

BEGIN
{
    $q = new CGI;
    $method = $q->param('method');

    #check if cookie exists. if yes, then try login.
    # else location = login.php

    %cookies = CGI::Cookie->fetch;

    if(!defined $cookies{'u_cookie'})
    {
        print $cookies{'u_cookie'}->value;
        print $q->header(-Location=>'login/login.php');

    }
    else
    {
        $got_u_cookie = $cookies{'u_cookie'}->value;
        $got_p_cookie = $cookies{'p_cookie'}->value;

        my $dbh_random123164 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost", "YellowFeather", "!",
        {'RaiseError' => 1});

        my $sth_random123164 = $dbh_random123164->prepare("SELECT u_cookie, p_cookie, username, email, valid FROM users WHERE u_cookie = ? AND p_cookie = ?");
        $sth_random123164->execute($got_u_cookie, $got_p_cookie) or die "Couldn't execute statement: $DBI::errstr; stopped";
        
        while(my($u_cookie, $p_cookie, $username, $email, $user_valid) = $sth_random123164->fetchrow_array())
        {
            print $real_username = decode_base64($username);
            print $real_email = $email;
            print $real_access = $user_valid;
            $valid = "ok";
        }
        $dbh_random123164->disconnect();

        if(!defined $valid)
        {
            print $cookies{'u_cookie'}->value;
            print $q->header(-Location=>'login/login.php');
        }
    }
    open(STDERR, ">&STDOUT");
}
1;


