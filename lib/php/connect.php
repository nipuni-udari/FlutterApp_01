<?php
ini_set('display_errors', 'off');

$servername = "payslip.lk";
$username = "NIPUNI";
$password = "Nipuni@1234";
$dbname = "service_desk";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
// echo $conn;

if (!$conn) {
	// die("Connection failed: " . mysqli_connect_error());


	//  header("location:404.html");
	//                 die();

} else {
//die("Connection success ");


}



?>