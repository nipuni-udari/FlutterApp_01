<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

//print_r($_POST);
session_start();
$da = date("Y-m-d H:i:s");
$da1 = date("Y-m-d");

// Prepare the response array
$response = array();

$stmt1 = $con_hel->prepare("UPDATE inquiry_details SET inquiry_last_status = ? WHERE inquiry_details_id = ?");
$stmt1->bind_param("si", $_POST['status'], $_POST['inquiry_id']);
if ($stmt1->execute()) {
    $stmt2 = $con_hel->prepare("INSERT INTO inquiry_remarks (inquiry_id, action_date, remarks, remark_update_date) VALUES (?, ?, ?, ?)");
    $stmt2->bind_param("isss", $_POST['inquiry_id'], $_POST['action_date'], $_POST['remarks'], $da1);
    if ($stmt2->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Status updated successfully';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Failed to insert remark: ' . $stmt2->error;
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Failed to update status: ' . $stmt1->error;
}


// Send the response as JSON
echo json_encode($response);
?>
