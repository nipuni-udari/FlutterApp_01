<?php
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $searchInput = isset($_GET['searchInput']) ? $_GET['searchInput'] : '';
    $query = "SELECT id, product_name FROM products WHERE product_name LIKE '%$searchInput%'";

    $result = mysqli_query($con_hel, $query);
    $products = [];

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $products[] = $row;
        }
    }

    header('Content-Type: application/json');
    echo json_encode($products);
}
?>
