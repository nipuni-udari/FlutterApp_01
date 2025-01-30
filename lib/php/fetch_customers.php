<?php
// Include database connection files
include('EMP_DB_connect.php');
include('conn_service_desk.php');
include('con_hel.php');
//print_r($_POST);

header('Content-Type: application/json'); // Set the content type to JSON

// Check if a search term is provided
$searchInput = isset($_GET['searchInput']) ? $_GET['searchInput'] : '';

// Get pagination parameters
$page = isset($_GET['page']) ? intval($_GET['page']) : 1; // Default to page 1
$itemsPerPage = isset($_GET['itemsPerPage']) ? intval($_GET['itemsPerPage']) : 50; // Default to 50 items per page

// Calculate the offset
$offset = ($page - 1) * $itemsPerPage;

// Build the query
$searchQuery = "SELECT customer_id, customer_company_name, customer_address 
                FROM customers 
                WHERE customer_company_name LIKE ? 
                LIMIT ? OFFSET ?";

// Prepare and execute the query
if ($stmt = $con_hel->prepare($searchQuery)) {
    $searchParam = "%$searchInput%";
    $stmt->bind_param("sii", $searchParam, $itemsPerPage, $offset);
    $stmt->execute();
    $result = $stmt->get_result();

    $customers = [];
    while ($row = $result->fetch_assoc()) {
        $customers[] = [
            'customer_id' => $row['customer_id'],
            'customer_company_name' => $row['customer_company_name'],
            'customer_address' => $row['customer_address']
        ];
    }

    // Count total records for pagination
    $countQuery = "SELECT COUNT(*) AS total FROM customers WHERE customer_company_name LIKE ?";
    if ($countStmt = $con_hel->prepare($countQuery)) {
        $countStmt->bind_param("s", $searchParam);
        $countStmt->execute();
        $countResult = $countStmt->get_result();
        $totalRecords = $countResult->fetch_assoc()['total'];
        $countStmt->close();
    } else {
        $totalRecords = 0; // Default to 0 if count query fails
    }

    // Return the data and pagination info as JSON
    echo json_encode([
        'data' => $customers,
        'pagination' => [
            'currentPage' => $page,
            'itemsPerPage' => $itemsPerPage,
            'totalRecords' => $totalRecords,
            'totalPages' => ceil($totalRecords / $itemsPerPage)
        ]
    ]);
} else {
    // If the query fails, return an error
    echo json_encode(['error' => 'Failed to execute query.']);
}

$con_hel->close(); // Close the database connection
?>
