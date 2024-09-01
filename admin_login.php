<?php
$servername = "localhost"; // Replace with your server name
$username = "root"; // Replace with your MySQL username
$password = ""; // Replace with your MySQL password
$dbname = "service"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$response = array();

if (isset($_POST['username']) && isset($_POST['password'])) {
    // Get POST data
    $post_username = $_POST['username'];
    $post_password = $_POST['password'];

    // Prepare and bind
    $stmt = $conn->prepare("SELECT * FROM admin WHERE username = ? AND password = ?");
    $stmt->bind_param("ss", $post_username, $post_password);

    // Execute statement
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $response['status'] = 'success';
    } else {
        $response['status'] = 'error';
    }

    // Close statement
    $stmt->close();
} else {
    $response['status'] = 'error';
    $response['message'] = 'Missing username or password';
}

// Close connection
$conn->close();

echo json_encode($response);
?>
