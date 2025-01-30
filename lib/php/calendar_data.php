<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

session_start();

$response = [];
$da = date("Y-m-d");

// Get the userHris value from the frontend
$userHris = $_POST['userHris'] ?? null;

if ($userHris) {
    // Query to fetch remarks for the relevant userHris
    $qrt5 = "
        SELECT 
            ir.action_date, 
            ir.remarks, 
            ir.remark_update_date 
        FROM 
            inquiry_remarks ir
        INNER JOIN 
            inquiry_details id 
        ON 
            ir.inquiry_id = id.inquiry_details_id
        WHERE 
            id.logged_by = '$userHris'
        ORDER BY 
            ir.action_date DESC
    ";

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
    $response['message'] = 'Invalid userHris';
}

echo json_encode($response);
?>
