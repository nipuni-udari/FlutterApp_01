<?php

ini_set('display_errors', 'on');
include('connect.php');
include('./ESMSWS.php');
// print_r($_POST);
$randomOtp = rand(100000, 999999);
$mobile = filter_input(INPUT_POST, 'mobile', FILTER_SANITIZE_NUMBER_INT); 

if (!$mobile || !ctype_digit($mobile)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid mobile number.']);
    exit;
}

// Check if the mobile number exists
$query = $conn->prepare("SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = ?");
$query->bind_param('s', $mobile);
$query->execute();
$result = $query->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['status' => 'error', 'message' => 'Mobile number not found. Please register.']);
    exit;
}

// Update OTP for the user
$updateQuery = $conn->prepare("UPDATE FLUTTER_APP_USERS SET OTP = ? WHERE MOBILE_NO = ?");
$updateQuery->bind_param('ss', $randomOtp, $mobile);


if ($updateQuery->execute()) {
    // Send OTP
    $message = "Dear User, Please use the OTP $randomOtp to reset your password.";
    $footer = "Fentons";
    $smsStatus = sendMSG("OTP Verification", $mobile, $message, $footer); // Send SMS OTP

    // Check SMS status and return appropriate response
    if ($smsStatus === 200) {
        echo json_encode(['status' => 'success', 'message' => 'OTP sent successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to send OTP']);
    }

} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update OTP.']);
}

// Function to send SMS using the external API
function sendMSG($subject, $to, $etxt, $footer) {
    $alias = "Fentons"; // Sender ID
    $message = $etxt . " " . $footer;
    $recipients = $to; // Recipient's phone number

    // Initialize session with credentials
    $session = createSession('', 'esmsusr_168l', '2pr8jmh', ''); // Replace with actual credentials
    $messageType = 0; // Message type: 0 for normal message

    // Send SMS via the gateway
    $smsStatus = sendMessages($session, $alias, $message, $recipients, $messageType);

    // Return the status of the SMS sending
    return $smsStatus; // Return the SMS status (either SUCCESS or ERROR)
}
?>
