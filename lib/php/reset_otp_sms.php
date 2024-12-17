<?php

ini_set('display_errors', 'on');
include('connect.php');

// Sanitize inputs
$mobile = filter_input(INPUT_POST, 'mobile', FILTER_SANITIZE_NUMBER_INT);
$otp = filter_input(INPUT_POST, 'otp', FILTER_SANITIZE_NUMBER_INT);

if (!$mobile || !$otp) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input.']);
    exit;
}

// Check if the OTP matches
$query = $conn->prepare("SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = ? AND OTP = ?");
$query->bind_param('ss', $mobile, $otp);
$query->execute();
$result = $query->get_result();

if ($result->num_rows > 0) {
    // OTP is valid, update the OTP field to a new value
    $newOtp = $otp; // Replace with the new OTP value you want to set
    $updateQuery = $conn->prepare("UPDATE FLUTTER_APP_USERS SET OTP = ? WHERE MOBILE_NO = ?");
    $updateQuery->bind_param('ss', $newOtp, $mobile);

    if ($updateQuery->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'OTP verified successfully and updated.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to update OTP.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid OTP.']);
}

// Close database connection
$conn->close();

?>
