<?php

$x = $_POST["value"];
$x = 2 * $x;

$result[] = array('result => $x, 'status' => 0, 'input => $_POST["value"], 'string' => "a string");

$js = json_encode($result);
echo $js;

?>
