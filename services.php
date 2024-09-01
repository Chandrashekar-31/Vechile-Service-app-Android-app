<?php
header('Content-Type: application/json');
// Handle CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Database configuration   
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "service"; // Update with your actual database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: ". $conn->connect_error);
}

// Handle GET request to fetch services
if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $sql = "SELECT id, service_name, description, price, vehicle_name FROM services";
    $result = $conn->query($sql);

    $services = array();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $services[] = $row;
        }
    }

    echo json_encode($services);
}

// Handle POST request to create service
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);
    $service_name = $data['service_name'];
    $description = $data['description'];
    $price = $data['price'];
    $vehicle_name = $data['vehicle_name'];

    // Prepare and bind SQL statement
    $stmt = $conn->prepare("INSERT INTO services (service_name, description, price, vehicle_name) VALUES (?,?,?,?)");
    $stmt->bind_param("ssds", $service_name, $description, $price, $vehicle_name);

    // Execute SQL statement
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to add service"));
    }

    $stmt->close();
}

// Handle DELETE request to delete service
if ($_SERVER["REQUEST_METHOD"] === "DELETE") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data['id'];

    // Prepare and bind SQL statement
    $stmt = $conn->prepare("DELETE FROM services WHERE id =?");
    $stmt->bind_param("i", $id);

    // Execute SQL statement
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to delete service"));
    }

    $stmt->close();
}

// Handle PUT request to edit service
if ($_SERVER["REQUEST_METHOD"] === "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data['id'];
    $service_name = $data['service_name'];
    $description = $data['description'];
    $price = $data['price'];
    $vehicle_name = $data['vehicle_name'];

    // Prepare and bind SQL statement
    $stmt = $conn->prepare("UPDATE services SET service_name =?, description =?, price =?, vehicle_name =? WHERE id =?");
    $stmt->bind_param("ssdsi", $service_name, $description, $price, $vehicle_name, $id);

    // Execute SQL statement
    if ($stmt->execute()) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update service"));
    }

    $stmt->close();
}

// Close connection
$conn->close();
?>