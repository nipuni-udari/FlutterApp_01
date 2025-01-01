<?php

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1); 
include('connect.php'); 

// print_r($_POST);
$mobile = $_POST['mobile'];
// echo $mobile;

$user_username = mysqli_real_escape_string($conn, $_POST['USERNAME']);
$user_password = mysqli_real_escape_string($conn, password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT));
$user_email = mysqli_real_escape_string($conn, $_POST['EMAIL']);
$user_address= mysqli_real_escape_string($conn, $_POST['USER_ADDRESS']);

// echo $user_address;
$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email'";
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {

    $existing_user = mysqli_fetch_assoc($result);
    if($existing_user['EMAIL'] === $user_email && $existing_user['USERNAME'] === $user_username){
        
        echo json_encode(['status' => 'email&UserNameExist', "message" => "Username & Email already exist"]);
    }
    elseif ($existing_user['EMAIL'] === $user_email) {
        echo json_encode(['status' => 'emailExist', "message" => "Email is already exist"]);
    } else {
        echo json_encode(['status' => 'userNameExist', "message" => "Username  already exists."]);
    }
} else {

    $sql_insert = "UPDATE FLUTTER_APP_USERS 
               SET USERNAME = '$user_username', 
                   TXT_PASSWORD = '$user_password', 
                   EMAIL = '$user_email', 
                   USER_ADDRESS = '$user_address'
               WHERE MOBILE_NO = '$mobile'";

    if ($conn->query($sql_insert) === TRUE) {
        echo json_encode(['status' => 'success', "message" => "User registered successfully."]);
    } else {
        echo json_encode(['status' => 'error', "message" => "Error: " . $conn->error]);
    }
}


mysqli_close($conn);
?>
