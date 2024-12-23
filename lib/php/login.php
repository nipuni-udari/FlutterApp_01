<?php

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1); 


include('connect.php'); 
// print_r($_POST);


$user_mobile = mysqli_real_escape_string($conn, $_POST['mobile']);
$user_password = mysqli_real_escape_string($conn, $_POST['password']);


$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = '$user_mobile'";
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {

    $user = mysqli_fetch_assoc($result);
    if (password_verify($user_password, $user['TXT_PASSWORD'])) {
       
        echo json_encode(["success" => true, "message" => "Login successful."]);
    } else {
       
        echo json_encode(["success" => false, "message" => "Invalid mobile or password."]);
    }
} else {

    echo json_encode(["failed" => false, "message" => "mobile not found."]);
    // echo json_encode($user_mobile);
}

mysqli_close($conn);
?>
