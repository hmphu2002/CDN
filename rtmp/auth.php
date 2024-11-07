<?php
// Define the path to the user credentials file
$users = file('auth.ini', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

// Get the required parameters from the query string
$app_name = $_GET['app'] ?? '';
$stream_name = $_GET['name'] ?? '';
$user = $_GET['user'] ?? '';
$password = $_GET['password'] ?? '';

$is_valid = false;

// Check each line in users.txt for a match
foreach ($users as $line) {
    // Parse app_name, stream_name, user, and password from the file
    list($file_app, $file_stream, $file_user, $file_password) = explode(":", $line);
    
    // Verify if all conditions match
    if ($file_app === $app_name && $file_stream === $stream_name && $file_user === $user && $file_password === $password) {
        $is_valid = true;
        break;
    }
}

// Respond based on validation result
if ($is_valid) {
    http_response_code(200); // Authentication successful
} else {
    http_response_code(401); // Authentication failed
}
?>
