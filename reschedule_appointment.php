<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "service";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    function sanitize_input($data) {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        return $data;
    }

    $appointment_id = sanitize_input($_POST['appointment_id']);
    $new_appointment_date = sanitize_input($_POST['new_appointment_date']);

    $sql = "UPDATE bookings SET appointment_date=?, status='rescheduled' WHERE id=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("si", $new_appointment_date, $appointment_id);

    if ($stmt->execute()) {
        echo "Appointment rescheduled successfully";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
    $conn->close();
} else {
    echo "Invalid request.";
}
?>
