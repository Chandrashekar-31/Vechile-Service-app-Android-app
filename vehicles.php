<?php
header('Content-Type: application/json');
// Handle CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS');

// Database configuration
$servername = "localhost";
$username = "root"; // Replace with your MySQL username
$password = ""; // Replace with your MySQL password
$dbname = "service"; // Replace with your database name where vehicles table exists

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set up request method handling
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        // Handle GET request to fetch all vehicles
        $sql = "SELECT id, vehicle_name, model, year FROM vehicles";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            $vehicles = array();
            while ($row = $result->fetch_assoc()) {
                $vehicles[] = $row;
            }
            echo json_encode($vehicles);
        } else {
            echo json_encode(array());
        }
        break;
        
    case 'POST':
        // Handle POST request to add a new vehicle
        $data = json_decode(file_get_contents("php://input"), true);
        $vehicle_name = $data['vehicle_name'];
        $model = $data['model'];
        $year = $data['year'];

        $sql = "INSERT INTO vehicles (vehicle_name, model, year) VALUES ('$vehicle_name', '$model', $year)";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(array("status" => "success", "message" => "Vehicle added successfully"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to add vehicle: " . $conn->error));
        }
        break;
        
    case 'PUT':
        // Handle PUT request to update a vehicle
        $data = json_decode(file_get_contents("php://input"), true);
        $id = $data['id'];
        $vehicle_name = $data['vehicle_name'];
        $model = $data['model'];
        $year = $data['year'];

        $sql = "UPDATE vehicles SET vehicle_name='$vehicle_name', model='$model', year=$year WHERE id=$id";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(array("status" => "success", "message" => "Vehicle updated successfully"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to update vehicle: " . $conn->error));
        }
        break;
        
    case 'DELETE':
        // Handle DELETE request to delete a vehicle
        $id = $_GET['id'];

        $sql = "DELETE FROM vehicles WHERE id=$id";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(array("status" => "success", "message" => "Vehicle deleted successfully"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to delete vehicle: " . $conn->error));
        }
        break;
        
    default:
        // Invalid request method
        header("HTTP/1.0 405 Method Not Allowed");
        echo json_encode(array("status" => "error", "message" => "Method not allowed"));
        break;
}

// Close connection
$conn->close();
?>
