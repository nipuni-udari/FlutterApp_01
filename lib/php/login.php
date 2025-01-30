<?php

header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);

include('connect.php');
include('EMP_DB_connect.php');

session_start();

$user_mobile = mysqli_real_escape_string($conn, $_POST['mobile']);
$user_password = mysqli_real_escape_string($conn, $_POST['password']);


// Check in FLUTTER_APP_USERS
$sql_check = "SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = '$user_mobile'" ;
$result = mysqli_query($conn, $sql_check);

if ($result && mysqli_num_rows($result) > 0) {
    $user = mysqli_fetch_assoc($result);
    if (password_verify($user_password, $user['TXT_PASSWORD'])) {
        $_SESSION['username'] = $user['USERNAME'];
        $_SESSION['userHris'] = $user['USER_ID'];
        echo json_encode([
            "success" => true,
            "message" => "Login successful.",
            "username" => $user['USERNAME'],
            "userHris" => $user['USER_ID'],
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid mobile or password."]);
    }
} else {
    // Check in EMB_DB
    $emb_query = "SELECT * FROM EMB_DB WHERE Mobile = '$user_mobile'";
    $emb_result = mysqli_query($DB_HRIS_conn, $emb_query);

    if ($emb_result && mysqli_num_rows($emb_result) > 0) {
        $emb_user = mysqli_fetch_assoc($emb_result);
        if ($user_password === $emb_user['PIN']) { 
            $_SESSION['username'] = $emb_user['CallingName'];
            $_SESSION['userHris'] = $emb_user['HRIS_NO'];
            echo json_encode([
                "success" => true,
                "message" => "Login.",
                "username" => $emb_user['CallingName'],
                "userHris" => $emb_user['HRIS_NO'],
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Invalid mobile or password."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Mobile not found."]);
    }
}

mysqli_close($conn);
mysqli_close($DB_HRIS_conn);
?>
