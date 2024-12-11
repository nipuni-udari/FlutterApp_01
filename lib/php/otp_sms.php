<?php

ini_set('display_errors', 'on');
include('connect.php');
include('ESMSWS.php');

$da = date('Y-m-d H:i:s');
$randomdata = rand(10000, 99999);

if (isset($_POST['contact'])) {
    $contact = $_POST['contact'];

    // Check if the user already exists
    $query = "SELECT * FROM FLUTTER_APP_USERS WHERE MOBILE_NO = '$contact'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        // User already exists
        echo json_encode([
            'status' => 'exists',
            'message' => 'User already exists. Please login.',
        ]);
    } else {
        // Save the new user
        $insertQuery = "INSERT INTO FLUTTER_APP_USERS (MOBILE_NO, REGISTER_DATE) VALUES ('$contact', '$da')";
        if (mysqli_query($conn, $insertQuery)) {
            // Send OTP
            $to = $contact;
            $subject = "OTP: $randomdata";
            $etxt = "Dear User, Please use the following OTP: $randomdata to complete your online request.";
            $footer = "IAssist Team";

            if (ctype_digit($to)) {
                $session = createSession('', 'esmsusr_OsnbfGmX', 'mhirmBJj', '');
                sendMessages($session, 'HAYLEYS SLR', $subject . "\n" . $etxt . "\n" . $footer, [$to], 1);
                closeSession($session);

                echo json_encode([
                    'status' => 'success',
                    'message' => 'OTP sent successfully.',
                    'otp' => $randomdata,
                ]);
            } else {
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Invalid mobile number.',
                ]);
            }
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Failed to register user.',
            ]);
        }
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Mobile number not provided.',
    ]);
}
?>
