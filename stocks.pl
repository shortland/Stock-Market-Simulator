#!/usr/bin/perl

use CGI;
use Digest::MD5;
use File::Temp qw(tempfile);
use HTTP::Cookies;
use LWP::UserAgent;
use MIME::Base64;
use DBI;
use DBI();

BEGIN{
    $cgi = new CGI;
    $username = $cgi->param("username");
    $password = $cgi->param("password");
    $hash = $cgi->param("hash");
    $method = $cgi->param("method");
    $method2 = $cgi->param("method2");
    $amount = $cgi->param("amount");
    $amount1 = $cgi->param("amount1");
    $amount2 = $cgi->param("amount2");
    $sell = $cgi->param("sell");
    $stock = $cgi->param("stock");
    $transaction = $cgi->param("transaction");
    $page = defined $cgi->param("page") ? $cgi->param("page") : "1";
    if(!defined $username){
        print $cgi->header(-type=>'text/html', -status=>'200 OK');
        print "no user";
        exit;
    } else {
        print $cgi->header(-type=>'text/html', -charset => 'UTF-8');
    }
    open(STDERR, ">&STDOUT");
}

# Remove these two lines in public environment
$db_password = "password";

if ($method =~ /^(ajaxsell)$/){
# get transaction. get amount in transaction current, see if current - sell = - must be positive
my $dbh13 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth13 = $dbh13->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT amount, symbol FROM portfolio WHERE transaction = '$transaction' AND username = '$username' AND hash = '$hash';
End_SQL
$sth13->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($amount, $symbol) = $sth13->fetchrow_array() ){
$portamount = $amount;
$stock = $symbol
};


$dbh13->disconnect();

my $dbh14 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth14 = $dbh14->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$stock';
End_SQL
$sth14->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($price) = $sth14->fetchrow_array() ){
$nowprice = $price
};
$dbh14->disconnect();

## we have Camount, stock, Cprice at this point

$positron = $portamount - $sell;
### positron is how many we have left after selling
if ($positron =~/^\-/ )
{
  print "Not enough stock";
  exit;
}



##update port-transaction with new amount
my $dbh15 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth15 = $dbh15->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
UPDATE portfolio SET amount = '$positron' WHERE transaction = '$transaction' AND username = '$username' AND hash = '$hash';
End_SQL
$sth15->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";
$dbh15->disconnect();

## update cash on hand
# $sell * $nowprice

$climax = $nowprice * 1.01;
$diff = $climax - $nowprice;
$nowvalue = $nowprice - $diff;
$total = $nowvalue * $sell;



# total = money we earned by selling those stocks
## update our cash on hand
my $dbh16 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth16 = $dbh16->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
UPDATE users SET cash = cash + $total WHERE username = '$username' AND hash = '$hash';
End_SQL
$sth16->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";
$dbh16->disconnect();

# we still need to update new stock price AND update # of stocks sold


if ($sell > 100){
print "greater than allowed transaction";
exit;
}
if ($sell > 0 ){
if ($sell =~ /^(1|2|3|4|5|6|7|8|9)$/) {
# .001
$newish = ".000${sell}";
$newam = "0${newish}";
}


if ($sell =~ /^(10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99)$/) {
# .001
$newish = ".00${sell}";
$newam = "0${newish}";
}
if ($sell =~ /^(100)$/) {
# .001
$newish = ".0${sell}";
$newam = "0${newish}";
}
}
else {
print "not a valid integer between 1 - 100 ( $sell )";
exit;
}

#assuming pricey is current price of stock -it is 
$summy = $nowprice * $newam;

$newval = $nowprice - $summy;
#print "newval: $newval";
#print "used: $newam";

# 100 * 0.001
# summy = .01


# 100 - .01 = newval

my $dbh17 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth17 = $dbh17->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
UPDATE stocks SET price = '$newval', sell = sell + $sell WHERE symbol = '$stock';
End_SQL
$sth17->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";
$dbh17->disconnect();


exit;
}




if ($method =~ /^(ajaxamount)$/){
## amount of stocks owned in a batch transaction
my $dbh12 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth12 = $dbh12->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT amount FROM portfolio WHERE transaction = '$transaction' AND username = '$username' AND hash = '$hash';
End_SQL
$sth12->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($amount) = $sth12->fetchrow_array() ){
print "$amount";
};
$dbh12->disconnect();
exit;
}



if ($method =~ /^(ajaxprice)$/){
## we get $symbol from param just need to select and print the price of symbol from stocks
my $dbh12 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth12 = $dbh12->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$stock';
End_SQL
$sth12->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($price) = $sth12->fetchrow_array() ){

$pricee = sprintf "%.2f", $price;
if ($method2 =~ /^(multiply)$/){
$priceee = $pricee * $amount1;
print $priceee;
exit;
};

print "\$$pricee";
};
$dbh12->disconnect();
exit;
}

if ($method =~ /^(multiply)$/){
$climax = $amount1 * 1.01;
$diff = $climax - $amount1;
$nowvalue = $amount1 - $diff;

if ($method2 =~ /^(buy)$/){
$totale = $nowvalue * $amount2;
$total = $totale + $amount1;
}
if ($method2 =~ /^(sell)$/){
$total = $nowvalue * $amount2;
}
print "\$$total";
exit;
}

# I think I want to have all of "sell" method be done with ajax lol
if ($method =~ /^(sell)$/) {

my $dbh11 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth11 = $dbh11->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT symbol, amount, price, total, symbol FROM portfolio WHERE transaction = '$transaction' AND username = '$username' AND hash = '$hash';
End_SQL
$sth11->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($symbol, $

	amount, $price, $total, $symboly) = $sth11->fetchrow_array() ){


my $dbh10 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth10 = $dbh10->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$symboly';
End_SQL
$sth10->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($pricer) = $sth10->fetchrow_array() ){
$stockprice = $pricer;
}
$dbh10->disconnect();




$html = qq{
<HTML>
<head>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=.9, user-scalable=no"/>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

</head>
<style>
    input[type=range] {
    -webkit-appearance: none;
    background-color: silver;
    width: 60%;
    height:20px;
}

input[type='range']::-webkit-slider-thumb {
     -webkit-appearance: none;
    background-color: #000000;
    opacity: 1.0;
    width: 15px;
    height: 26px;
    border-radius: 4px;
    border: 1px solid grey;
}
</style>
<script type='text/javascript'>
    function updateTextInput(val) {
      document.getElementById('textInput').value=val; 
    }
</script>

<p>Owned stocks in this batch: <span id="amount"></span></p>
<p>Purchased at: \$$price </p>
<p>Current price: <span id="stockprice"></span></p>


<form action='stocks.pl' method='' name='form1'>
<input type="number" min="1" max="$amount" name='amount' id='textInput' value='1' style='width:50px;font-weight:bold;font-size:100%;height:20px;'>
<input type='range'  name='rangeInput' step='1' min='1' max='$amount' onchange='updateTextInput(this.value);'>
<input type='hidden' name='current' value='$stockprice'>
<input type='hidden' name='method' value='sellit'>
<input type='hidden' name='stock' value='$stock'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='transaction' value='$transaction'>
<input type='hidden' name='hash' value='$hash'>	
</form>				

<button type="button" onClick='ajaxsell()'>Sell</button>

<script>
(function loadXMLDoc()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=multiply&method2=sell&username=root&amount1=" + document.form1.current.value + "&amount2=" + document.form1.amount.value,true);
xmlhttp.send();

setTimeout(loadXMLDoc, 400);
})();


(function getprice()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("stockprice").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=ajaxprice&username=root&stock=" + document.form1.stock.value,true);
xmlhttp.send();

setTimeout(getprice, 3000);
})();


(function getamount()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("amount").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=ajaxamount&username=" + document.form1.username.value + "&transaction=" + document.form1.transaction.value + "&hash=" + document.form1.hash.value,true);
xmlhttp.send();

setTimeout(getamount, 3000);
})();


function ajaxsell()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("amount").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=ajaxsell&username=" + document.form1.username.value + "&transaction=" + document.form1.transaction.value + "&hash=" + document.form1.hash.value + "&sell=" + document.form1.amount.value,true);
xmlhttp.send();

setTimeout(sellmess, 100);
};

function sellmess() {

};

</script>	       
<div id="myDiv"></div>


};
print $html;
};
$dbh11->disconnect();

exit;
};






if ($method =~ /^(portcheck)$/) {
### select all transactions from portfolio, allow to sell as only function
my $dbh8 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

print "<table border='1px'><tr>
<td>Stock</td>
<td>Amount</td>
<td>Buy Price</td>
<td>Buy Value</td>
<td>Estimate Value</td>
<td>Sell</td>
<td>Buy Date</td>
</tr>";
my $sth8 = $dbh8->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT symbol, amount, price, total, time, transaction FROM portfolio WHERE username = '$username' AND hash = '$hash' AND symbol = '$stock' AND amount > 0;
End_SQL
$sth8->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($symbol, $amount, $price, $total, $timestamp, $transaction) = $sth8->fetchrow_array() ){

$pricee = sprintf "%.2f", $price;
$totale = sprintf "%.2f", $total;

my $dbh9 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth9 = $dbh9->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$symbol';
End_SQL
$sth9->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($currentprice) = $sth9->fetchrow_array() ){
#
#
#
# HERE IS OUR LITTLE PROBLEM SET TO:
# WHY? otherwise people can buy then just sell back infinitely.
# set to -'3' of actual current stock price. (individual count)
# 3 (6/14/14)
# 
#
#
#
#
#
$climax = $currentprice * 1.01;
$diff = $climax - $currentprice;
$nowvalue = $currentprice - $diff;
};
$dbh9->disconnect();

$nowprice = $nowvalue * $amount;
$nowpricee = sprintf "%.2f", $nowprice;

$tdata = qq{
<tr>
<td>$symbol</td>
<td>#$amount</td>
<td>\$$pricee</td>
<td>\$$totale</td>
<td>\$$nowpricee</td>
<td><form action='stocks.pl' method=''>
<input type='hidden' name='method' value='sell'>
<input type='hidden' name='stock' value='$symbol'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='hash' value='$hash'>	
<input type='hidden' name='transaction' value='$transaction'>
<input type='submit' value='Sell'>
</form
</td>
<td>$timestamp</td>
</tr>};
print $tdata;


};
$dbh8->disconnect();
print "</table>";
exit;
};

if ($method =~ /^(portfolio)$/) {

$starttable = qq{
<form name='form1'>
<input type='hidden' name='stock' value='$symbol'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='hash' value='$hash'>	
<input type='hidden' name='transaction' value='$transaction'>
</form>
<table border='1px'>
<tr>
<td>Stock</td>
<td>Amount Owned</td>
<td>Value*</td>
<td>Details</td>
</tr>
};
print $starttable;




my $dbh6 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

### this is going to be a bit ugly and will probably impact server speed by A LOT... ugh.
my $sth6 = $dbh6->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT symbol, SUM(amount), transaction FROM portfolio WHERE username = '$username' AND hash = '$hash' GROUP BY symbol ORDER BY time DESC
End_SQL
$sth6->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($symbol, $

	sum, $transactione) = $sth6->fetchrow_array() ){


my $dbh7 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

#get current value of the stock
my $sth7 = $dbh7->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$symbol';
End_SQL
$sth7->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($price) = $sth7->fetchrow_array() ){
$teaprice1 = $price * $sum;

$teaprice2 = sprintf "%.2f", $teaprice1;


my $tea3=$teaprice2;
$tea3 =~ s/(\d)(?=(\d{3})+(\D|$))/$1\,/g;
$tea4 = $tea3;
};
$dbh7->disconnect();

$ajaxvalue = qq{
<script>
(function loadXMLDoc()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("$transactione").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=ajaxprice&method2=multiply&username=root&amount1=$sum&stock=$symbol",true);
xmlhttp.send();

setTimeout(loadXMLDoc, 400);
})();
</script>
};

$table = qq{
<tr>
<td>$symbol</td>
<td>$sum</td>
<td><span id='$transactione'></span><!--- \$$tea4 ---></td>
<td><form action='stocks.pl' method=''>
<input type='hidden' name='method' value='portcheck'>
<input type='hidden' name='stock' value='$symbol'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='hash' value='$hash'>	
<input type='submit' value='More'>
</form>
</td>
</tr>


};
print $table;
print $ajaxvalue;

};
$dbh6->disconnect();

$endtable = qq{

</tr>
</table>
};
print $endtable;

exit;
};




if ($method =~ /^(buyit)$/) {
my $dbh = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth = $dbh->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$stock';
End_SQL
$sth->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($price) = $sth->fetchrow_array() ){
# sum is the grand total of the stocks
$sum = $price * $amount;
$pricey = $price;
};
$dbh->disconnect();


print $sum;

my $dbh2 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth2 = $dbh2->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT cash FROM users WHERE hash = '$hash' AND username = '$username';
End_SQL
$sth2->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($cash) = $sth2->fetchrow_array() ){
# result is our money - price 
$result = $cash - $sum;

if ( $result >= 0 )
{
   $valid = "yes";
print "have nuff";
}
if ($result =~/^\-/ )
{
  print "Not enough money";
  exit;
}


};
$dbh2->disconnect();

if ($valid =~ /^(yes)$/) {
## we have enough mone

#y, now lets 'subtract it'
# $result UPDATE users SET cash = $result WHERE username = '$username' AND hash = '$hash'

my $dbh3 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth3 = $dbh3->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
UPDATE users SET cash = '$result' WHERE username = '$username' AND hash = '$hash';
End_SQL
$sth3->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

$dbh3->disconnect();




my $dbh4 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my @chars = ("A".."Z", "a".."z", "1".."9",);
my $random;
$random .= $chars[rand @chars] for 1..16;

if (!defined $pricey){
print "Nonexistent stock";
exit;
};

my $sth4 = $dbh4->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
INSERT INTO portfolio (`username`, `hash`, `symbol`, `amount`, `price`, `total`, `time`, `transaction`) VALUES ('$username', '$hash', '$stock', '$amount', '$pricey', '$sum', CURRENT_TIMESTAMP, '$random');
End_SQL
$sth4->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

$dbh4->disconnect();


### this isnt all that great of a way, better: $pricey * 1.$amount_of_stocks_in_market
### bit broken, buy 1 stock will increase value same as if buy 100 stocks
## fix attemp #1 6/14/14 


if ($amount =~/^\-/ ) {

print "error: neg int";
exit;
}

if ($amount > 100){
print "greater than allowed transaction";
exit;
}
if ($amount > 0 ){
if ($amount =~ /^(1|2|3|4|5|6|7|8|9)$/) {
# .001
$newish = ".000${amount}";
$newam = "1${newish}";
}


if ($amount =~ /^(10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99)$/) {
# .001
$newish = ".00${amount}";
$newam = "1${newish}";
}
if ($amount =~ /^(100)$/) {
# .001
$newish = ".0${amount}";
$newam = "1${newish}";
}
}
else {
print "not a valid integer between 1 - 100";
exit;
}

$oneval = $pricey * $newam;


my $dbh5 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth5 = $dbh5->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
UPDATE stocks SET price = '$oneval', buy = buy + $amount WHERE symbol = '$stock';
End_SQL
$sth5->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

$dbh5->disconnect();




print "Purchase complete. $result money left.";
};
exit;
};








if ($method =~ /^(buy)$/) {
# get current price of stock
my $dbh18 = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});
my $sth18 = $dbh18->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT price FROM stocks WHERE symbol = '$stock';
End_SQL
$sth18->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($pricer) = $sth18->fetchrow_array() ){
$stockprice = $pricer;
}
$dbh18->disconnect();

## multiply amount and amount2
$html = qq{
<HTML>
<head>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=.9, user-scalable=no"/>
</head>
<style>
    input[type=range] {
    -webkit-appearance: none;
    background-color: silver;
    width: 60%;
    height:20px;
}

input[type='range']::-webkit-slider-thumb {
     -webkit-appearance: none;
    background-color: #000000;
    opacity: 1.0;
    width: 15px;
    height: 26px;
    border-radius: 4px;
    border: 1px solid grey;
}
</style>


<script type='text/javascript'>
    function updateTextInput(val) {
      document.getElementById('textInput').value=val; 
    }
</script>

<form action='stocks.pl' method='' name='form1'>
<input type="number" min="1" max="100" name='amount' id='textInput' value='1' style='width:50px;font-weight:bold;font-size:100%;height:20px;'>
<input type='range'  name='rangeInput' step='1' min='1' max='100' onchange='updateTextInput(this.value);'>
<input type='hidden' name='method' value='buyit'>
<input type='hidden' name='stock' value='$stock'>
<input type='hidden' name='amount2' value='$stockprice'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='hash' value='$hash'>	
<input type='submit' value='buy'>
</form>
<script>
(function getamount()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("amount").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","stocks.pl?method=multiply&method2=buy&username=" + document.form1.username.value + "&amount1=" + document.form1.amount.value + "&amount2=" + document.form1.amount2.value,true);
xmlhttp.send();

setTimeout(getamount, 500);
})();
</script>
					       
<div id='amount'></div>
};
print $html;
exit;
}


## begin of table we dont want to loop this in the sql query

$start = qq{
<HTML>
<head>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=.9, user-scalable=no"/>
</head>
<table border='1px' >
<tr>
<td>Symbol</td>
<td>Name</td>
<td>Price</td>
<td>Total Bought</td>
<td>Total Sold</td>
<td>Buy</td>
</tr>};


print $start;

my $dbh = DBI->connect("DBI:mysql:database=ilankleiman;host=localhost",
"YellowFeather", "$db_password",
{'RaiseError' => 1});

my $sth = $dbh->prepare(<<End_SQL) or die "Couldn't prepare statement: $DBI::errstr; stopped";
SELECT ID, symbol, name, price, sell, buy FROM stocks ORDER BY buy DESC;
End_SQL
$sth->execute() or die "Couldn't execute statement: $DBI::errstr; stopped";

while ( my ($ID, $symbol, $name, $price, $sell, $buy) = $sth->fetchrow_array() ){

$pricey = sprintf "%.2f", $price;
    $table = qq{

<tr>
<td>$symbol</td>
<td>$name</td>
<td>\$$pricey</td>
<td>#$buy</td>
<td>#$sell</td>
<td><form action='stocks.pl' method=''>
<input type='hidden' name='method' value='buy'>
<input type='hidden' name='stock' value='$symbol'>
<input type='hidden' name='username' value='$username'>
<input type='hidden' name='hash' value='$hash'>
<input type='submit' value='buy'>
</form></td>
</tr>

        
    };
    print $table;
    
}

$dbh->disconnect();

print "</table>";