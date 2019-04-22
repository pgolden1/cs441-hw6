<?php

$user = $_POST["username"];
$pass = $_POST["password"];

$dbname = "jkunnum1_studdyBuddyUsers";
$dbuser = "jkunnum1";
$dbpwd = "xxxxxxx";
$host = "mysql.cs.binghamton.edu";

$cid = mysqli_connect($host, $dbuser, $dbpwd, $dbname);
if ($cid) {
    $sql = "select * from users";
    $query_result = mysqli_query($cid, $sql);
    $found = 0;
    while ($row = mysqli_fetch_array($query_result, MYSQLI_ASSOC)) {
	    if ($row["username"] == $user && $row["password"] == $pass) {
		    $found = 1;
		    $result[] = array('result' => 1, 'status' => 0, 'user' => $user);
	}
    }
    if (!$found) {
	$result[] = array('result' => 0, 'status' => 0, 'user' => $_POST["username"]);
    }
} else {
    $result[] = array('result' => 0, 'status' => 1, 'user' => $_POST["username"]);
}

$js = json_encode($result);
echo $js;

?>
