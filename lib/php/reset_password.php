<?php

ini_set('display_errors', 'on');
error_reporting(E_ALL);

include('connect.php');

$passwordResetDate = date('Y-m-d H:i:s');

// Sanitize inputs
$mobile = isset($_POST['mobile']) ? trim($_POST['mobile']) : null;
$newPassword = isset($_POST['new_password']) ? trim($_POST['new_password']) : null;
$confirmPassword = isset($_POST['confirm_password']) ? trim($_POST['confirm_password']) : null;


// Check if the mobile number exists
$query = $conn->prepare("SELECT MOBILE_NO FROM FLUTTER_APP_USERS WHERE MOBILE_NO = ?");
$query->bind_param('s', $mobile);
$query->execute();
$result = $query->get_result();

if ($result->num_rows > 0) {
    // Hash the new password
    $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);

    // Update the password
    $updateQuery = $conn->prepare(
        "UPDATE FLUTTER_APP_USERS 
         SET TXT_PASSWORD = ?, PASSWORD_RESET_DATE = ? 
         WHERE MOBILE_NO = ?"
    );
    $updateQuery->bind_param('sss', $hashedPassword, $passwordResetDate, $mobile); // Bind all three parameters

    if ($updateQuery->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Password reset successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to reset password.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Mobile number not found.']);
}

// Close database connection
$conn->close();

?>
