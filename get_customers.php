<?php
header('Content-Type: application/json');
// Handle CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

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

// Fetch customers
$sql = "SELECT id, username, email FROM users";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $customers = array();
    while($row = $result->fetch_assoc()) {
        $customers[] = $row;
    }
    echo json_encode($customers);
} else {
    echo json_encode(array()); // Return empty array if no customers found
}

$conn->close();
?>
