<?php
// Register API to handle user sign-up
header('Content-Type: application/json');

// Include the database connection from connect.php
include('connect.php'); // This assumes connect.php is in the same directory as register.php

// Get POST data
$user_username = $_POST['USERNAME'];
$user_password = password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT); // Hash the password
$user_email = $_POST['EMAIL'];
$user_mobile = $_POST['MOBILE_NO'];

// Check if the username or email already exists
$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email'";
$result = mysqli_query($conn, $sql_check);

if (mysqli_num_rows($result) > 0) {
    echo json_encode(["success" => false, "message" => "Username or email already exists."]);
} else {
    // Insert new user data
    $sql_insert = "INSERT INTO users (USERNAME, PASSWORD, EMAIL, MOBILE_NO) VALUES ('$user_username', '$user_password', '$user_email', '$user_mobile')";
    
    if (mysqli_query($conn, $sql_insert)) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . mysqli_error($conn)]);
    }
}

// Close connection
mysqli_close($conn);
?>
