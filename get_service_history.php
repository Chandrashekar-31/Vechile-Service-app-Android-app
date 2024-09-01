<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "service";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if 'user_id' parameter is present in the query string
if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];

    $sql = "SELECT * FROM bookings WHERE user_id = '$user_id'";
    $result = mysqli_query($conn, $sql);

    $history = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $history[] = $row;
    }

    echo json_encode($history);
} else {
    echo json_encode(array("error" => "User ID not provided"));
}

mysqli_close($conn);
?>
