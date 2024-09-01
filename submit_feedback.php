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

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : null;
$feedback = isset($_POST['feedback']) ? $_POST['feedback'] : null;
$suggestions = isset($_POST['suggestions']) ? $_POST['suggestions'] : '';
$rating = isset($_POST['rating']) ? $_POST['rating'] : null;

if ($user_id && $feedback && $rating) {
  $sql = "INSERT INTO feedback (user_id, feedback, suggestions, rating) VALUES (?, ?, ?, ?)";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("isss", $user_id, $feedback, $suggestions, $rating);

  if ($stmt->execute()) {
    echo "New record created successfully";
  } else {
    echo "Error: " . $stmt->error;
  }

  $stmt->close();
} else {
  echo "Error: Missing user_id, feedback, or rating";
}

$conn->close();
?>
