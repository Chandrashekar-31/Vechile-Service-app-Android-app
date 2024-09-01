<?php
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";  // Your database server
$username = "root";  // Your database username
$password = "";  // Your database password
$dbname = "service";  // Your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(array("status" => "error", "message" => "Connection failed: " . $conn->connect_error)));
}

// Get the raw POST data
$data = json_decode(file_get_contents("php://input"));

if ($data === null) {
    echo json_encode(array("status" => "error", "message" => "Invalid JSON input."));
    exit;
}

$name = $conn->real_escape_string($data->name);
$email = $conn->real_escape_string($data->email);
$message = $conn->real_escape_string($data->message);

// Insert into database
$sql = "INSERT INTO contacts (name, email, message) VALUES ('$name', '$email', '$message')";
if ($conn->query($sql) === TRUE) {
    echo json_encode(array("status" => "success", "message" => "Your message has been received!"));
} else {
    echo json_encode(array("status" => "error", "message" => "Error: " . $sql . "<br>" . $conn->error));
}

$conn->close();
?>
