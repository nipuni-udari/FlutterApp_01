<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');
//print_r($_POST);


$response = [];
$da = date("Y-m-d");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $companyName = $_POST['companyName'] ?? '';
    $email = $_POST['email'] ?? '';
    $companyAddress = $_POST['companyAddress'] ?? '';
    $contactNo = $_POST['contactNo'] ?? '';
    $latitude = $_POST['latitude']??'';
    $longitude = $_POST['longitude']??'';

    if (!empty($companyName) && !empty($email) && !empty($companyAddress) && !empty($contactNo)) {
        $query = "INSERT INTO customers (customer_company_name , customer_email, customer_address, customer_contact_no, customer_longitude, customer_latitude)
                  VALUES ('$companyName', '$email', '$companyAddress', '$contactNo' , '$longitude', '$latitude' )";

        if (mysqli_query($con_hel, $query)) {
            $response['success'] = true;
        } else {
            $response['success'] = false;
            $response['message'] = 'Database error: ' . mysqli_error($con_hel);
        }
    } else {
        $response['success'] = false;
        $response['message'] = 'All fields are required.';
    }
} else {
    $response['success'] = false;
    $response['message'] = 'Invalid request method.';
}

echo json_encode($response);
?>