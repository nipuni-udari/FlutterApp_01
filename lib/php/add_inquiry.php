<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');
// print_r($_POST);
$refNo = $_POST['refNo'] ?? '';
$customerId = $_POST['customerId'] ?? '';
$productId = $_POST['product'] ?? '';
$qty = $_POST['qty'] ?? 0;
$proValue = $_POST['proValue'] ?? 0;
$da = date('Y-m-d H:i:s'); // Current date and time for inquiry
$da1 = date('Y-m-d H:i:s'); // Assuming the last follow-up date is the same as the current date

if (empty($refNo) || empty($customerId) || empty($productId)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required fields']);
    exit;
}

// Check if inquiry already exists
$qrt = "SELECT * FROM inquiry_details WHERE inquiry_refno = ?";
$stmt = $con_hel->prepare($qrt);
$stmt->bind_param('s', $refNo);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $insertedId = $row['inquiry_details_id'];
} else {
    // Insert new inquiry
    $sql1 = "INSERT INTO inquiry_details (inquiry_refno, inquiry_dateTime, customer_id, logged_by, inquiry_last_status) 
             VALUES (?, ?, ?, 'test', 'ONGOING')";
    $stmt1 = $con_hel->prepare($sql1);
    $stmt1->bind_param('ssi', $refNo, $da, $customerId);

    if ($stmt1->execute()) {
        $insertedId = $con_hel->insert_id;
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to create inquiry']);
        exit;
    }
}

// Insert product into temp_inquiry_product
$sql2 = "INSERT INTO temp_inquiry_product (inquiry_id, product_id, product_qty, total_value, last_followup_date, last_status, submitted_dateTime) 
         VALUES (?, ?, ?, ?, ?, 'TEMP', ?)";
$stmt2 = $con_hel->prepare($sql2);
$stmt2->bind_param('iiidss', $insertedId, $productId, $qty, $proValue, $da1, $da);

if ($stmt2->execute()) {
    echo json_encode(['success' => 'Product added successfully']);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to add product']);
}

?>
