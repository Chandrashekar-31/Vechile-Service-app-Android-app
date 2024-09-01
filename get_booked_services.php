<?php
// Database connection details
$servername = "localhost"; // Replace with your MySQL server name
$username = "root"; // Replace with your MySQL username
$password = ""; // Replace with your MySQL password
$database = "service"; // Replace with your MySQL database name

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to fetch booked services
$sql = "SELECT * FROM bookings"; // Replace with your table name and structure

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Array to hold booked services data
    $bookedServices = array();

    // Fetch data from each row
    while ($row = $result->fetch_assoc()) {
        $bookedServices[] = $row;
    }

    // Return booked services data as JSON
    header('Content-Type: application/json');
    echo json_encode($bookedServices);
} else {
    // If no booked services found
    echo "No booked services found";
}

$conn->close();
?>
