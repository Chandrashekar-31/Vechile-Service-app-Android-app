<?php
header('Content-Type: application/json');
// Handle CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: DELETE');

// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "service"; // Update with your actual database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Decode JSON data from request body
$data = json_decode(file_get_contents("php://input"), true);

// Check if customerId is set and not empty
if (isset($data['customerId']) && !empty($data['customerId'])) {
    $customerId = $conn->real_escape_string($data['customerId']);

    // Delete customer
    $sql = "DELETE FROM users WHERE id = $customerId";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(array('status' => 'success'));
    } else {
        echo json_encode(array('status' => 'error', 'message' => $conn->error));
    }
} else {
    echo json_encode(array('status' => 'error', 'message' => 'CustomerId is missing or empty'));
}

$conn->close();
?>
