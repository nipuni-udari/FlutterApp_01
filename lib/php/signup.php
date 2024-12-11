<?php

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1); 


include('connect.php'); 


$user_username = mysqli_real_escape_string($conn, $_POST['USERNAME']);
$user_password = mysqli_real_escape_string($conn, password_hash($_POST['PASSWORD'], PASSWORD_DEFAULT));
$user_email = mysqli_real_escape_string($conn, $_POST['EMAIL']);
$user_mobile = mysqli_real_escape_string($conn, $_POST['MOBILE_NO']);


$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE USERNAME = '$user_username' OR EMAIL = '$user_email' OR MOBILE_NO = '$user_mobile'";
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {

    $existing_user = mysqli_fetch_assoc($result);
    if ($existing_user['MOBILE_NO'] == $user_mobile) {
        echo json_encode(["success" => false, "message" => "Mobile number is already exist.Please login"]);
    } else {
        echo json_encode(["success" => false, "message" => "Username or email already exists."]);
    }
} else {

    $sql_insert = "INSERT INTO FLUTTER_APP_USERS (USERNAME, TXT_PASSWORD, EMAIL, MOBILE_NO) 
                   VALUES ('$user_username', '$user_password', '$user_email', '$user_mobile')";

    if ($conn->query($sql_insert) === TRUE) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
}


mysqli_close($conn);
?>
