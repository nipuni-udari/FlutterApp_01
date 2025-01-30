<?php
header('Content-Type: application/json');
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inquiry_id = $_POST['inquiry_id'];

    $response = [];
    $productTotal = 0;

    $query = "SELECT p.product_name, tip.product_qty, tip.total_value 
              FROM temp_inquiry_product tip 
              INNER JOIN products p ON tip.product_id = p.id 
              WHERE tip.inquiry_id = '$inquiry_id' AND tip.last_status = 'TEMP'";

    $result = mysqli_query($con_hel, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $response['products'][] = $row;
            $productTotal += $row['total_value'];
        }
    }

    $response['total'] = number_format($productTotal, 2);
    echo json_encode($response);
} else {
    echo json_encode(['error' => 'Invalid request']);
}
?>
