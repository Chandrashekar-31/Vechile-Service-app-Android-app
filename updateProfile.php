<?php
header('Content-Type: application/json');

// Database connection parameters
$servername = "localhost"; // or your server address
$username = "root"; // replace with your MySQL username
$password = ""; // replace with your MySQL password
$dbname = "service"; // replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// Get the JSON input
$data = json_decode(file_get_contents('php://input'), true);

// Check if required fields are present
if (isset($data['name']) && isset($data['email']) && isset($data['phone']) && isset($data['user_id'])) {
    $name = $data['name'];
    $email = $data['email'];
    $phone = $data['phone'];
    $userId = $data['user_id']; // Assuming user ID is passed

    // Prepare the update query
    $query = "UPDATE users SET name = ?, email = ?, phone = ? WHERE id = ?";
    $stmt = $conn->prepare($query);
    
    if ($stmt) {
        $stmt->bind_param("sssi", $name, $email, $phone, $userId);
        
        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Profile updated successfully."]);
        } else {
            echo json_encode(["success" => false, "message" => "Error updating profile: " . $stmt->error]);
        }
        
        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Error preparing statement: " . $conn->error]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid input."]);
}

$conn->close(); // Close the connection
?>
