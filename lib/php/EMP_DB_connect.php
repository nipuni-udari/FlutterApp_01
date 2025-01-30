<?php
$servername = "dblink1";
$username = "root";
$password = "sat.com";
$dbname = "DB_HRIS";

// Create connection
$DB_HRIS_conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection

//echo $conn;

if (!$DB_HRIS_conn) {
    //die("Connection failed: " . mysqli_connect_error());
	
	
	   header("location:404.html");
                         die();

	
}else{
//die("Connection success ");
	
	
	}
	
	
	
?>