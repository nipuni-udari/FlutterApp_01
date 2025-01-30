<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

header('Content-Type: text/plain'); // Ensure plain text response
session_start();

if (!isset($_GET['userHris']) || empty($_GET['userHris'])) {
    die('Error: userHris parameter is missing or empty.');
}

$user_hris = mysqli_real_escape_string($con_hel, $_GET['userHris']);

$query = "SELECT COUNT(inquiry_details_id) AS count 
          FROM inquiry_details 
          WHERE inquiry_last_status='PROSPECT' 
          AND logged_by = '$user_hris'";

$result = mysqli_query($con_hel, $query);

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo $row['count'];
} else {
    echo 0; // Default to 0 if no result
}
?>
