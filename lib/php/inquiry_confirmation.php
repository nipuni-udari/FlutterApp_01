<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inquiryId = $_POST['inquiryId'];
    $totalValue = $_POST['Totalval'];

    $sql = "UPDATE inquiry_details 
            SET inquiry_total = '$totalValue', 
                inquiry_last_status = 'ONGOING' 
            WHERE inquiry_details_id = '$inquiryId'";

    if ($con_hel->query($sql) === TRUE) {
        echo "You have successfully placed the order.";
    } else {
        echo "Error: " . $sql . "<br>" . $con_hel->error;
    }
} else {
    echo "Invalid request method.";
}
?>
