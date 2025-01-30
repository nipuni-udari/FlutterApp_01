<?php
$servername = "dblink1";
$username = "root";
$password = "sat.com";
$dbname = "hel_db";

// Create connection
$con_hel = mysqli_connect($servername, $username, $password, $dbname);
// Check connection

if (!$con_hel) {
    //die("Connection failed: " . mysqli_connect_error());
	header("location:404.html");
    die();
}else{
//die("Connection success ");
}
?>