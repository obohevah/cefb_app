<?php
/**
 * Gallery API endpoint for Christ Embassy Farmers Branch Mobile App
 * Returns active albums and their associated pictures in clean JSON
 */

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

if (file_exists(__DIR__ . "/db.php")) {
    require_once __DIR__ . "/db.php";
} elseif (file_exists(__DIR__ . "/../db.php")) {
    require_once __DIR__ . "/../db.php";
} else {
    header("Content-Type: application/json; charset=UTF-8");
    echo json_encode(["status" => "error", "message" => "Database configuration not found"]);
    exit;
}

mysqli_set_charset($con, 'utf8mb4');

$cacheFile = __DIR__ . "/gallery_cache.json";
$cacheDuration = 300; // 5 minutes cache for speed

if (!isset($_GET['refresh']) && file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheDuration) {
    echo file_get_contents($cacheFile);
    exit;
}

$albums = [];
$albumQuery = "SELECT id, title, description, sort_order FROM gallery_albums WHERE status = 'active' ORDER BY sort_order ASC, id ASC";
$albumRows = mysqli_query($con, $albumQuery);

if ($albumRows) {
    while ($album = mysqli_fetch_assoc($albumRows)) {
        $albumId = (int)$album['id'];
        $imgQuery = "SELECT id, image_path, sort_order FROM gallery_images WHERE album_id = $albumId ORDER BY sort_order ASC, id ASC";
        $imgRows = mysqli_query($con, $imgQuery);

        $images = [];
        if ($imgRows) {
            while ($img = mysqli_fetch_assoc($imgRows)) {
                $images[] = $img['image_path'];
            }
        }

        $albums[] = [
            'id'            => $albumId,
            'title'         => $album['title'],
            'description'   => $album['description'] ?? '',
            'coverImage'    => count($images) > 0 ? $images[0] : null,
            'imageCount'    => count($images),
            'images'        => $images
        ];
    }
}

$output = json_encode(['status' => 'success', 'count' => count($albums), 'albums' => $albums]);
file_put_contents($cacheFile, $output);

echo $output;
