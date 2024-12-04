<?php
// Register API to handle user sign-up
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1); // Corrected to enable error display

// Include the database connection from connect.php
include('connect.php'); // Ensure this file has the correct database connection details

// Get POST data and sanitize inputs to prevent SQL injection
$user_username = mysqli_real_escape_string($conn, $_POST['USERNAME']);
$user_password = mysqli_real_escape_string($conn, password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT));
$user_email = mysqli_real_escape_string($conn, $_POST['EMAIL']);
$user_mobile = mysqli_real_escape_string($conn, $_POST['MOBILE_NO']);

// Check if the username or email already exists
$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email'";
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {
    echo json_encode(["success" => false, "message" => "Username or email already exists."]);
} else {
    // Insert new user data
    $sql_insert = "INSERT INTO FLUTTER_APP_USERS (USERNAME, TXT_PASSWORD, EMAIL, MOBILE_NO) 
                   VALUES ('$user_username', '$user_password', '$user_email', '$user_mobile')";

    if ($conn->query($sql_insert) === TRUE) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
}

// Close connection
mysqli_close($conn);
?>
