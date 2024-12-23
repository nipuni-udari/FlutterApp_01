<?php

ini_set('display_errors', 'on');
include('connect.php');
include('./ESMSWS.php'); // Include SMS sending class

$randomOtp = rand(100000, 999999);
$mobile = filter_input(INPUT_POST, 'mobile', FILTER_SANITIZE_NUMBER_INT); // Validate mobile number

if (!$mobile || !ctype_digit($mobile)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid mobile number.']);
    exit;
}

// Check if the mobile number already exists
$query = $conn->prepare("SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = ?");
$query->bind_param('s', $mobile);
$query->execute();
$result = $query->get_result();

if ($result->num_rows > 0) {
    echo json_encode(['status' => 'exists', 'message' => 'You are already registered. Please proceed to log in.']);
    exit;
}

// Save the new user
$registerDate = date('Y-m-d H:i:s');
$insertQuery = $conn->prepare("INSERT INTO FLUTTER_APP_USERS (MOBILE_NO, REGISTER_DATE, OTP) VALUES (?, ?, ?)");
$insertQuery->bind_param('sss', $mobile, $registerDate, $randomOtp);

if ($insertQuery->execute()) {
    // Send OTP
    $message = "Dear User, Please use the OTP $randomOtp to complete your registration.";
    $footer = "Fentons";
    $smsStatus = sendMSG("OTP Verification", $mobile, $message, $footer); // Send SMS OTP

    
    // Check SMS status and return appropriate response
    if ($smsStatus === 200) {
        echo json_encode(['status' => 'success', 'message' => 'OTP sent successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to send OTP']);
    }
    
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to register user.']);
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