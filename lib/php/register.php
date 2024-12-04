<?php
// Register API to handle user sign-up
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', on);


// Include the database connection from connect.php
include('connect.php'); // This assumes connect.php is in the same directory as register.php

// Get POST data
$user_username = $_POST['USERNAME'];
$user_password = password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT);
$user_email = $_POST['EMAIL'];
$user_mobile = $_POST['MOBILE_NO'];

// Check if the username or email already exists
// $sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email'";
// $result = mysqli_query($conn, $sql_check);

    // Insert new user data
    $sql_insert = "INSERT INTO FLUTTER_APP_USERS SET USERNAME = '".$user_username."', TXT_PASSWORD = '".$user_password."', EMAIL = '".$user_email."', MOBILE_NO = '".$user_mobile."'";
     
    echo $sql_insert;
    if ($conn -> query($sql_insert) === TRUE) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn -> error()]);
    }


// Close connection
mysqli_close($conn);
?>
