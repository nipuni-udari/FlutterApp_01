<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

session_start();

$response = [];
$da = date("Y-m-d");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $postData = json_decode(file_get_contents("php://input"), true);
    if ($postData) {
        $_POST = $postData;
    }

    if (empty($_POST)) {
        $response['success'] = false;
        $response['error'] = "No data received in POST request.";
        echo json_encode($response);
        exit;
    }

    $inquiryId = $con_hel->real_escape_string($_POST['inquiryId']);
    $updateActionDate = $con_hel->real_escape_string($_POST['update_action_date'] ?? '');
    $inqUpdateRemark = $con_hel->real_escape_string($_POST['inq_update_remark'] ?? '');

    if (!empty($updateActionDate) && !empty($inqUpdateRemark)) {
        $sql1 = "INSERT INTO inquiry_remarks (inquiry_id, action_date, remarks, remark_update_date)
                 VALUES ('$inquiryId', '$updateActionDate', '$inqUpdateRemark', '$da')";

        if ($con_hel->query($sql1) === TRUE) {
            $response['success'] = true;
            $response['message'] = "Remark added successfully!";
        } else {
            $response['success'] = false;
            $response['error'] = "Error inserting remark: " . $con_hel->error;
        }
    }

    $qrt5 = "SELECT * FROM inquiry_remarks WHERE inquiry_id = '$inquiryId' ORDER BY action_date DESC";
    $result5 = mysqli_query($con_hel, $qrt5);

    $remarks = [];
    if (mysqli_num_rows($result5) > 0) {
        while ($row = mysqli_fetch_assoc($result5)) {
            $remarks[] = [
                'action_date' => $row['action_date'],
                'remarks' => $row['remarks'],
                'remark_update_date' => $row['remark_update_date'],
            ];
        }
    }

    $response['remarks'] = $remarks;
} else {
    $response['success'] = false;
    $response['error'] = "Invalid request method. Only POST is allowed.";
}

echo json_encode($response);
?>
