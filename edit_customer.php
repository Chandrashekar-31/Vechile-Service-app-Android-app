<?php
header('Content-Type: application/json');

// Check if the request contains valid JSON data
$data = json_decode(file_get_contents('php://input'), true);

if ($data === null) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON data received']);
    exit;
}

// Extract data from JSON
$id = isset($data['id']) ? $data['id'] : null;
$username = isset($data['username']) ? $data['username'] : null;
$email = isset($data['email']) ? $data['email'] : null;
$phone = isset($data['phone']) ? $data['phone'] : null;

// Validate required fields
if ($id === null || $username === null || $email === null || $phone === null) {
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
    exit;
}

// Perform database operations
$conn = new mysqli('localhost', 'root', '', 'service');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Use prepared statements to prevent SQL injection
$stmt = $conn->prepare("UPDATE users SET username=?, email=?, phone=? WHERE id=?");
$stmt->bind_param("sssi", $username, $email, $phone, $id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $conn->error]);
}

$stmt->close();
$conn->close();
?>
