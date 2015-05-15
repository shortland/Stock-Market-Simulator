#!/usr/bin/perl

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use MIME::Base64;
use DBI;
use CGI::Cookie;

BEGIN 
{
	$cgi = new CGI;
	#$username = $cgi->param("username");

}
require "login/cookie_login.pl";

print $real_username;

print qq
{
<p>This is cookie protected!</p>
<p>Members only content here!</p>
};