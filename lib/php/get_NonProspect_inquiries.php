<?php
header('Content-Type: application/json');
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

$response = [];

$qrt = "SELECT * FROM inquiry_details WHERE inquiry_last_status='NON_PROSPECT' and logged_by = '" . mysqli_real_escape_string($con_hel, $_POST['userHris']) . "' ORDER BY inquiry_dateTime desc";
$result = mysqli_query($con_hel, $qrt);

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $customer_name = "";
        $qrt5 = "SELECT * FROM customers WHERE customer_id = '" . mysqli_real_escape_string($con_hel, $row['customer_id']) . "'";
        $result5 = mysqli_query($con_hel, $qrt5);

        if (mysqli_num_rows($result5) > 0) {
            $row5 = mysqli_fetch_assoc($result5);
            $customer_name = $row5['customer_company_name'];
        }

        $last_action_date = "";
        $qrt6 = "SELECT * FROM inquiry_remarks WHERE inquiry_id = '" . mysqli_real_escape_string($con_hel, $row['inquiry_details_id']) . "' ORDER BY action_date DESC LIMIT 1";
        $result6 = mysqli_query($con_hel, $qrt6);

        if (mysqli_num_rows($result6) > 0) {
            $row6 = mysqli_fetch_assoc($result6);
            $last_action_date = $row6['action_date'];
        }

        // Query for products count
        $products_count = 0;
        $qrt1 = "SELECT COUNT(p.product_name) AS count 
                 FROM temp_inquiry_product tip 
                 INNER JOIN products p ON tip.product_id = p.id 
                 WHERE tip.inquiry_id = '" . mysqli_real_escape_string($con_hel, $row['inquiry_details_id']) . "' AND tip.last_status='TEMP'";
        $result1 = mysqli_query($con_hel, $qrt1);

        if (mysqli_num_rows($result1) > 0) {
            $row1 = mysqli_fetch_assoc($result1);
            $products_count = $row1['count'];
        }

        // Query for total amount
        $total_amount = 0;
        $qrt2 = "SELECT SUM(total_value) AS total_value 
                 FROM inquiry_details 
                 INNER JOIN temp_inquiry_product ON temp_inquiry_product.inquiry_id = inquiry_details.inquiry_details_id 
                 WHERE inquiry_last_status ='NON_PROSPECT' and logged_by = '" . mysqli_real_escape_string($con_hel, $_POST['userHris']) . "' and inquiry_refno = '" . mysqli_real_escape_string($con_hel, $row['inquiry_refno']) . "'";
        $result2 = mysqli_query($con_hel, $qrt2);

        if (mysqli_num_rows($result2) > 0) {
            $row2 = mysqli_fetch_assoc($result2);
            $total_amount = $row2['total_value'];
        }

        // Calculate days count
        $days_count = 0;
        if (!empty($row['inquiry_dateTime'])) {
            $inquiry_date = new DateTime($row['inquiry_dateTime']);
            $current_date = new DateTime();
            $days_count = $inquiry_date->diff($current_date)->days;
        }

        $response[] = [
            'customer_name' => $customer_name,
            'action_date' => $last_action_date,
            'products' => $products_count,
            'amount' => number_format($total_amount, 2), // Format to 2 decimal places
            'days' => $days_count,
            'inquiry_id' => $row['inquiry_details_id'], // Add this line
        ];
    }
}

echo json_encode($response);
?>
