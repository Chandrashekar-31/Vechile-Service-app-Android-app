<?php
header('Content-Type: application/json');

// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "service"; // Use your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(array('status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error)));
}

// Check if username and password are set
if (!isset($_POST['username'], $_POST['password'])) {
    die(json_encode(array('status' => 'error', 'message' => 'Username or password missing.')));
}

$username = $_POST['username'];
$password = $_POST['password'];

// Query to check if user exists
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo json_encode(array('status' => 'success', 'message' => 'Login successful.'));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Invalid username or password.'));
}

$conn->close();
?>
