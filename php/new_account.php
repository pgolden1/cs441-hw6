<?php

$user = $_POST["username"];
$pass = $_POST["password"];
$first = $_POST["first"];
$last = $_POST["last"];
$email = $_POST["email"];

$dbname = "jkunnum1_studdyBuddyUsers";
$dbuser = "jkunnum1";
$dbpwd = "xxxxxxx";
$host = "mysql.cs.binghamton.edu";

$cid = mysqli_connect($host, $dbuser, $dbpwd, $dbname);
if ($cid) {
    $sql = "select * from users where username = \"{$_POST["username"]}\"";
    $query_result = mysqli_query($cid, $sql);
    if ($query_result) {
      $row_cnt = mysqli_num_rows($query_result);
      if ($row_cnt == 0) {
        $sql = "insert into users (first_name, last_name, email, username, password) values (\"{$_POST["first"]}\", \"{$_POST["last"]}\", \"{$_POST["email"]}\", \"{$_POST["username"]}\", \"{$_POST["password"]}\")";
        if (mysqli_query($cid, $sql)) {
          $result[] = array('result' => 1, 'user' => $_POST["username"], 'error' => 0);
        } else {
          $result[] = array('result' => 0, 'user' => $_POST["username"], 'error' => 4);
        }
      } else {
        $result[] = array('result' => 0, 'user' => $user, 'error' => 3);
      }
    } else {
      $result[] = array('result' => 0, 'user' => $user, 'error' => 2);
    }
} else {
  $result[] = array('result' => 0, 'user' => $user, 'error' => 1);
}

$js = json_encode($result);
echo $js;

?>
