<?php
$username_safe = addslashes($_POST['username']);
$password_safe = addslashes($_POST['password']);
$method_safe = addslashes($_POST['method']);
$b64_username = base64_encode(addslashes($_POST['username']));
$b64_password = base64_encode(addslashes($_POST['password']));
if (!isset($_POST["method"]) && empty($_POST["method"])) {
echo "<form action='login.php' method='POST'>\n";
echo "Username: <input type='text' name='username'/><br>\n";
echo "Password: <input type='password' name='password'/><br>\n";
echo "<input type='hidden' name='method' value='login'/>\n";
echo "<input type='submit' value='Login'/><br>\n";
echo "</form>\n";
die();
} elseif ($method_safe == "login"){
function randomString($length = 24) {
    $characters = '1234567890poiuytrewqasdfghjklmnbvcxzQAZWSXEDCRFVTGBYHNUJMIKLOP';
    $String = '';
    for ($i = 0; $i < $length; $i++) {
        $String .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $String;
}
$connect = mysqli_connect("localhost","YellowFeather","!","ilankleiman");
if (mysqli_connect_errno()) {
  echo "CANT CONNECT:" . mysqli_connect_error();
}
$login = mysqli_query($connect, "SELECT `username`, `password`, `salt` FROM `users` WHERE `username` = '$b64_username'");
while($row = mysqli_fetch_array($login)) {
  $salt = $row['salt'];
  $hashed = crypt($b64_password, $salt);
  $got_password = $row['password'];
  
  $valid = "ok";
}
if (!isset($valid)){
echo "Invalid Username $b64_username";
die();
}
if($hashed == $got_password){
$u_cookie = randomString();
$p_cookie = randomString();
$today_date = date('Y-m-d');
mysqli_query($connect, "UPDATE `users` SET `u_cookie` = '$u_cookie', `p_cookie` = '$p_cookie', `cookie_set` = '$today_date' WHERE `username` = '$b64_username' AND `password` = '$hashed'");
setcookie("u_cookie", $u_cookie, time()+3600, "/", "ilankleiman.com", 1);
setcookie("p_cookie", $p_cookie, time()+3600, "/", "ilankleiman.com", 1);

header('Location: ../portfolio.pl');
echo "Logging in";
mysqli_close($connect);
die();
} else {
echo "Invalid Password.";
die();
}
}