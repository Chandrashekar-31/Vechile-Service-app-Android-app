<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "service";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Debugging lines to print POST data
echo '<pre>';
print_r($_POST);
echo '</pre>';

$user_id = $_POST['user_id'] ?? null;
$vehicle = $_POST['vehicle'] ?? null;
$service = $_POST['service'] ?? null;
$model = $_POST['model'] ?? null;
$appointment_date = $_POST['appointment_date'] ?? null;

if ($user_id && $vehicle && $service && $model && $appointment_date) {
    $sql = "INSERT INTO bookings (user_id, vehicle, service, model, appointment_date)
    VALUES ('$user_id', '$vehicle', '$service', '$model', '$appointment_date')";

    if ($conn->query($sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
} else {
    echo "Missing required fields";
}

$conn->close();
?>
