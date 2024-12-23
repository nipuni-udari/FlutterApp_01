<?php

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1); 
include('connect.php'); 

//print_r($_POST);

$user_username = mysqli_real_escape_string($conn, $_POST['USERNAME']);
$user_password = mysqli_real_escape_string($conn, password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT));
$user_email = mysqli_real_escape_string($conn, $_POST['EMAIL']);
$user_address= mysqli_real_escape_string($conn, $_POST['USER_ADDRESS']);


$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email'";
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {

    $existing_user = mysqli_fetch_assoc($result);
    if ($existing_user['EMAIL'] == $user_email) {
        echo json_encode(["success" => false, "message" => "Email is already exist"]);
    } else {
        echo json_encode(["success" => false, "message" => "Username  already exists."]);
    }
} else {

    $sql_insert = "INSERT INTO FLUTTER_APP_USERS (USERNAME, TXT_PASSWORD, EMAIL, USER_ADDRESS) 
                   VALUES ('$user_username', '$user_password', '$user_email', '$user_address')";

    if ($conn->query($sql_insert) === TRUE) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
}


mysqli_close($conn);
?>
