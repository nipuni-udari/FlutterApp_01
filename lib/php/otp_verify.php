<?php

ini_set('display_errors', 'on');
include('connect.php');
// print_r($_POST);
$mobile = $_POST['mobile'];

$otp = $_POST['otp'];



// Check if the mobile number exists and the OTP matches
$query = $conn->prepare("SELECT OTP FROM FLUTTER_APP_USERS WHERE MOBILE_NO = ?");
$query->bind_param('s', $mobile);
$query->execute();
$result = $query->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if ($user['OTP'] == $otp) {
        echo json_encode(['status' => 'success', 'message' => 'OTP verified successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid OTP.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Mobile number not found.']);
}
?>
