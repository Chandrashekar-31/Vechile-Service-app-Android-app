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

$sql = "SELECT user_id, feedback, suggestions, rating FROM feedback";
$result = $conn->query($sql);

$feedbacks = array();

if ($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
    // Ensure data types are correct
    $row['user_id'] = (int)$row['user_id']; // Ensure user_id is an integer
    $row['rating'] = (float)$row['rating']; // Ensure rating is a float
    $feedbacks[] = $row;
  }
} 
echo json_encode($feedbacks);

$conn->close();
?>
