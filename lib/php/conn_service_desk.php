<?php
$servername = "dblink1";
$username = "root";
$password = "sat.com";
$dbname = "service_desk";

// Create connection
$conn_service_desk = mysqli_connect($servername, $username, $password, $dbname);
// Check connection

if (!$conn_service_desk) {
    //die("Connection failed: " . mysqli_connect_error());
	header("location:404.html");
    die();
}else{
//die("Connection success ");
}
?>