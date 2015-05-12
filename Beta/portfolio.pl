#!/usr/bin/perl

use CGI;
use DBI;
use MIME::Base64;

BEGIN
{
    $cgi = new CGI;
    $username = $cgi->param("username");
   # print $cgi->header(-type=>'text/html', -status=>'200 OK', -charset => 'UTF-8');
    #open(STDERR, ">&STDOUT");
}
require "login/cookie