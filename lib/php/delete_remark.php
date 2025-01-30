<?php 
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

//print_r($_POST);
session_start();

$response = [];
$todayDate = date("Y-m-d");

//echo $todayDate;

if (isset($_POST['inquiry_id']) && isset($_POST['action_date'])) {
    $inquiryId = $_POST['inquiry_id'];
    $actionDate = $_POST['action_date'];
//echo $actionDate;

    if ($actionDate === $todayDate) { 
        $sql = "DELETE FROM inquiry_remarks WHERE inquiry_id = '$inquiryId' AND action_date = '$actionDate'";

        if ($con_hel->query($sql) === TRUE) {
            $response['status'] = 'success';
            $response['message'] = 'Remark deleted successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Failed to delete remark.';
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Cannot delete remarks with a date other than today.';
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request. Missing inquiry ID or action date.';
}

echo json_encode($response);
?>
