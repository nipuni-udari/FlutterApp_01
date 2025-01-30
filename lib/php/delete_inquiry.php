<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

$response = []; // Initialize response array

$inquiryId = $_POST['inquiryId'];

// Check if remarks exist for the inquiry
$checkRemarksQuery = "SELECT * FROM inquiry_remarks WHERE inquiry_id = '$inquiryId'";
$result = mysqli_query($con_hel, $checkRemarksQuery);

if (mysqli_num_rows($result) > 0) {
    // Remarks exist, return error response
    $response = [
        'status' => 'error',
        'message' => 'Cannot delete the inquiry as remark(s) already added.'
    ];
} else {
    // Delete from temp_inquiry_product
    $deleteTempQuery = "DELETE FROM temp_inquiry_product WHERE inquiry_id = '$inquiryId'";
    $con_hel->query($deleteTempQuery);

    // Delete from inquiry_details
    $deleteDetailsQuery = "DELETE FROM inquiry_details WHERE inquiry_details_id = '$inquiryId'";
    if ($con_hel->query($deleteDetailsQuery) === TRUE) {
        $response = [
            'status' => 'success',
            'message' => 'Inquiry deleted successfully.'
        ];
    } else {
        $response = [
            'status' => 'error',
            'message' => 'Failed to delete the inquiry. Please try again.'
        ];
    }
}

// Return JSON response
header('Content-Type: application/json');
echo json_encode($response);
?>
