<?php
/**
 * Christ Embassy Farmers Branch - Dynamic Popups API
 * Returns active, unexpired popups/flyers configured in the admin dashboard.
 */

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Connect to database
$con = null;
if (file_exists(__DIR__ . "/db.php")) {
    require_once __DIR__ . "/db.php";
} elseif (file_exists(__DIR__ . "/../db.php")) {
    require_once __DIR__ . "/../db.php";
} elseif (file_exists(__DIR__ . "/../../db.php")) {
    require_once __DIR__ . "/../../db.php";
}

$baseUrl = "https://christembassyfarmersbranch.org";

// Fallback slides in case database is unreachable
$defaultSlides = [
    [
        "id" => 2,
        "title" => "Sunday Service",
        "image" => "$baseUrl/mt-content/uploads/2025/02/43.jpg",
        "delay" => 1,
        "once_per_session" => false
    ],
    [
        "id" => 3,
        "title" => "Wednesday Service",
        "image" => "$baseUrl/mt-content/uploads/2025/02/44.jpg",
        "delay" => 1,
        "once_per_session" => false
    ]
];

if (!$con) {
    echo json_encode(["status" => "success", "slides" => $defaultSlides]);
    exit;
}

mysqli_set_charset($con, 'utf8mb4');

$today = date('Y-m-d');
$query = "SELECT id, title, image_path, delay_seconds, once_per_session, sort_order 
          FROM popups 
          WHERE status = 'active' 
          AND (start_date IS NULL OR start_date <= '$today')
          AND (end_date IS NULL OR end_date >= '$today')
          ORDER BY sort_order ASC, id ASC";

$result = mysqli_query($con, $query);
$slides = [];

if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $imgPath = $row['image_path'];
        // Normalize URL if relative
        if (strpos($imgPath, 'http') !== 0) {
            $imgPath = ltrim($imgPath, '.');
            $imgPath = ltrim($imgPath, '/');
            $imgPath = "$baseUrl/$imgPath";
        }

        $slides[] = [
            "id" => (int)$row['id'],
            "title" => $row['title'],
            "image" => $imgPath,
            "delay" => (int)$row['delay_seconds'],
            "once_per_session" => (bool)$row['once_per_session']
        ];
    }
}

// If no active popups found in popups table, check popup_images or fallback
if (empty($slides)) {
    $imgQuery = "SELECT id, image_path, sort_order FROM popup_images ORDER BY sort_order ASC, id ASC";
    $imgRes = mysqli_query($con, $imgQuery);
    if ($imgRes && mysqli_num_rows($imgRes) > 0) {
        while ($row = mysqli_fetch_assoc($imgRes)) {
            $imgPath = $row['image_path'];
            if (strpos($imgPath, 'http') !== 0) {
                $imgPath = ltrim($imgPath, '.');
                $imgPath = ltrim($imgPath, '/');
                $imgPath = "$baseUrl/$imgPath";
            }
            $slides[] = [
                "id" => (int)$row['id'],
                "title" => "Church Announcement",
                "image" => $imgPath,
                "delay" => 1,
                "once_per_session" => false
            ];
        }
    }
}

if (empty($slides)) {
    $slides = $defaultSlides;
}

echo json_encode(["status" => "success", "slides" => $slides]);
