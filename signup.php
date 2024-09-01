<?php
// Set headers for JSON response
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
    $response = array('status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error);
    die(json_encode($response));
}

// Check if all required POST parameters are set
if (!isset($_POST['username'], $_POST['password'], $_POST['email'], $_POST['phone'])) {
    $response = array('status' => 'error', 'message' => 'Missing parameters.');
    die(json_encode($response));
}

// Get input data (sanitize inputs if needed)
$user = $conn->real_escape_string($_POST['username']);
$pass = $conn->real_escape_string($_POST['password']);
$email = $conn->real_escape_string($_POST['email']);
$phone = $conn->real_escape_string($_POST['phone']);

// Check if user already exists
$sql = "SELECT * FROM users WHERE username='$user'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response = array('status' => 'error', 'message' => 'Username already exists.');
    echo json_encode($response);
} else {
    // Insert new user
    $sql_insert = "INSERT INTO users (username, password, email, phone) VALUES ('$user', '$pass', '$email', '$phone')";
    
    if ($conn->query($sql_insert) === TRUE) {
        $response = array('status' => 'success', 'message' => 'User registered successfully.');
        echo json_encode($response);
    } else {
        $response = array('status' => 'error', 'message' => 'Error: ' . $conn->error);
        echo json_encode($response);
    }
}

// Close connection
$conn->close();
?>
