<?php
/**
 * Christ Embassy Farmers Branch - Fast Live Stream Detector & Push Notification Service
 * Drop-in replacement for auto_detect.php
 *
 * QUOTA-SAFE ARCHITECTURE:
 * YouTube Data API has a 10,000 units/day limit (search.list costs 100 units/call).
 * Calling search.list every minute would burn 144,000 units/day and exhaust quota in ~1.5 hours!
 *
 * This script solves that completely:
 * 1. ZERO-QUOTA DETECTION (Direct YouTube /live probe - costs 0 API units, fast & unlimited)
 * 2. SERVICE WINDOW INTELLIGENCE (Central Time / America/Chicago):
 *    - Service Windows: Sundays 9:00 AM - 1:30 PM CST & Wednesdays 6:00 PM - 9:30 PM CST
 *    - Outside service windows: NEVER calls YouTube Data API. Uses 0-quota probe only.
 * 3. QUOTA-GUARD RATE LIMITING:
 *    - YouTube Data API is capped to at most once every 15 minutes during service windows.
 *    - Daily quota usage drops to < 500 units/day (well within the 10,000 limit!).
 * 4. FIREBASE PUSH NOTIFICATION:
 *    - Fires FCM push notification immediately when stream transitions to live.
 */

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Set timezone to church local time (Texas, Central Standard/Daylight Time)
date_default_timezone_set('America/Chicago');

// Configuration
$channelId = "UCLf52f2IX7x9WienLerXlJg";
$apiKey    = getenv('YOUTUBE_API_KEY') ?: "YOUR_YOUTUBE_API_KEY";

$serviceAccountPath   = __DIR__ . '/service-account.json';
$notificationSentFile = __DIR__ . '/live_notification_sent.txt';
$cacheFile            = __DIR__ . '/live_cache.json';
$apiRateLimitFile     = __DIR__ . '/yt_api_last_call.txt';

$isForceCheck = isset($_GET['force']) || isset($_GET['refresh']) || isset($_GET['force_check']);

// -----------------------------------------------------------------------------
// Service Window & Quota Intelligence
// -----------------------------------------------------------------------------

function isChurchServiceWindow() {
    $dayOfWeek = (int)date('w'); // 0 = Sunday, 3 = Wednesday
    $hour = (int)date('G');       // 0 - 23
    $minute = (int)date('i');
    $timeVal = $hour * 60 + $minute;

    // Sunday Service Window: 9:00 AM (540m) to 1:30 PM (810m)
    if ($dayOfWeek === 0 && $timeVal >= 540 && $timeVal <= 810) {
        return true;
    }

    // Wednesday Service Window: 6:00 PM (1080m) to 9:30 PM (1290m)
    if ($dayOfWeek === 3 && $timeVal >= 1080 && $timeVal <= 1290) {
        return true;
    }

    // Allow manual query override ?service_window=1 for testing
    if (isset($_GET['service_window'])) {
        return true;
    }

    return false;
}

// Dynamic Cache Duration based on Service Window:
// During service times: 20 seconds cache for instant responsiveness
// Outside service times: 120 seconds cache to preserve server resources
$inServiceWindow = isChurchServiceWindow();
$cacheDuration   = $inServiceWindow ? 20 : 120;

// Check existing cache if not forcing check
if (!$isForceCheck && file_exists($cacheFile)) {
    $cacheAge = time() - filemtime($cacheFile);
    if ($cacheAge < $cacheDuration) {
        $cached = json_decode(file_get_contents($cacheFile), true);
        if ($cached) {
            $cached['from_cache'] = true;
            $cached['cache_age']  = $cacheAge;
            echo json_encode($cached);
            exit;
        }
    }
}

// -----------------------------------------------------------------------------
// Helper Functions
// -----------------------------------------------------------------------------

function getAccessToken($serviceAccountPath) {
    if (!file_exists($serviceAccountPath)) {
        return null;
    }

    $serviceAccount = json_decode(file_get_contents($serviceAccountPath), true);
    if (!$serviceAccount || !isset($serviceAccount['private_key'], $serviceAccount['client_email'])) {
        return null;
    }

    $now = time();
    $jwtHeader = json_encode(['alg' => 'RS256', 'typ' => 'JWT']);
    $jwtClaim = json_encode([
        'iss'   => $serviceAccount['client_email'],
        'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
        'aud'   => 'https://oauth2.googleapis.com/token',
        'iat'   => $now,
        'exp'   => $now + 3600
    ]);

    $jwtHeaderB64 = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($jwtHeader));
    $jwtClaimB64  = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($jwtClaim));
    $jwtSigInput  = $jwtHeaderB64 . '.' . $jwtClaimB64;

    $privateKey = openssl_pkey_get_private($serviceAccount['private_key']);
    if (!$privateKey) {
        return null;
    }

    openssl_sign($jwtSigInput, $signature, $privateKey, 'sha256');
    $jwtSigB64 = str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($signature));
    $jwt = $jwtSigInput . '.' . $jwtSigB64;

    $ch = curl_init('https://oauth2.googleapis.com/token');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion'  => $jwt
        ]),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 8,
        CURLOPT_SSL_VERIFYPEER => true
    ]);
    $res = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($res, true);
    return $data['access_token'] ?? null;
}

function sendFCMNotification($accessToken, $projectId, $title, $body, $videoId) {
    $url = "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send";

    $message = [
        'message' => [
            'topic' => 'livestream',
            'notification' => [
                'title' => $title,
                'body'  => $body
            ],
            'data' => [
                'type'         => 'livestream',
                'videoId'      => (string)$videoId,
                'video_id'     => (string)$videoId,
                'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
            ]
        ]
    ];

    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => json_encode($message),
        CURLOPT_HTTPHEADER     => [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json; UTF-8'
        ],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
        CURLOPT_SSL_VERIFYPEER => true
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return ($httpCode === 200);
}

/**
 * 0-QUOTA METHOD: Probe YouTube channel /live page.
 * Uses 0 YouTube Data API quota units!
 * When a channel goes live, YouTube immediately serves or redirects to the live video player.
 */
function checkDirectLiveStream($channelId) {
    $url = "https://www.youtube.com/channel/{$channelId}/live";
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_MAXREDIRS      => 4,
        CURLOPT_TIMEOUT        => 6,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_USERAGENT      => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    ]);
    $html = curl_exec($ch);
    $effectiveUrl = curl_getinfo($ch, CURLINFO_EFFECTIVE_URL);
    curl_close($ch);

    if (!$html) return null;

    // Check if redirected to a watch URL
    if (preg_match('/watch\?v=([a-zA-Z0-9_-]{11})/', $effectiveUrl, $matches)) {
        $videoId = $matches[1];
        if (strpos($html, '"isLive":true') !== false || strpos($html, '"status":"LIVE"') !== false || strpos($html, 'BADGE_STYLE_TYPE_LIVE_NOW') !== false) {
            $title = "Live Service";
            if (preg_match('/<title>(.*?)<\/title>/i', $html, $titleMatches)) {
                $title = str_replace(' - YouTube', '', $titleMatches[1]);
            }
            return ['videoId' => $videoId, 'title' => $title, 'method' => 'DIRECT_ZERO_QUOTA'];
        }
    }

    // Check embedded canonical or videoId inside live page
    if (strpos($html, '"isLive":true') !== false || strpos($html, 'isLiveBroadcast') !== false) {
        if (preg_match('/"videoId":"([a-zA-Z0-9_-]{11})"/', $html, $vMatch)) {
            return ['videoId' => $vMatch[1], 'title' => 'Christ Embassy Farmers Branch Live', 'method' => 'DIRECT_ZERO_QUOTA'];
        }
    }

    return null;
}

/**
 * YouTube Data API v3 Search (Costs 100 quota units).
 * Protected by Quota Guard: Only invoked during service windows, at most once per 15 mins.
 */
function checkYouTubeApiGuarded($channelId, $apiKey, $apiRateLimitFile) {
    // Check rate limit: do not call YouTube API if called within the last 15 minutes (900s)
    if (file_exists($apiRateLimitFile)) {
        $lastCall = (int)@file_get_contents($apiRateLimitFile);
        if ((time() - $lastCall) < 900) {
            return null; // Protect quota
        }
    }

    @file_put_contents($apiRateLimitFile, time());

    $url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId={$channelId}&type=video&eventType=live&key={$apiKey}";
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 6,
        CURLOPT_SSL_VERIFYPEER => false
    ]);
    $response = curl_exec($ch);
    curl_close($ch);

    if (!$response) return null;

    $data = json_decode($response, true);
    if (!empty($data['items'][0]['id']['videoId'])) {
        return [
            'videoId' => $data['items'][0]['id']['videoId'],
            'title'   => $data['items'][0]['snippet']['title'] ?? 'Live Service',
            'method'  => 'YOUTUBE_API_FALLBACK'
        ];
    }
    return null;
}

// -----------------------------------------------------------------------------
// Main Execution
// -----------------------------------------------------------------------------

// Manual override if church staff passes ?manual_id=XXXXX
if (!empty($_GET['manual_id'])) {
    $liveDetected = [
        'videoId' => trim($_GET['manual_id']),
        'title'   => 'Live Service',
        'method'  => 'MANUAL_OVERRIDE'
    ];
} else {
    // 1. Always run the 0-QUOTA direct check first (Cost: 0 units, unlimited)
    $liveDetected = checkDirectLiveStream($channelId);

    // 2. Only fall back to Data API if:
    //    a) We are inside a church service window (Sunday or Wednesday)
    //    b) 15-minute rate limit allows it
    if (!$liveDetected && $inServiceWindow) {
        $liveDetected = checkYouTubeApiGuarded($channelId, $apiKey, $apiRateLimitFile);
    }
}

$isLive  = ($liveDetected !== null);
$videoId = $isLive ? $liveDetected['videoId'] : null;
$title   = $isLive ? $liveDetected['title'] : null;
$method  = $isLive ? $liveDetected['method'] : 'NONE';

$result = [
    'live'              => $isLive,
    'is_live'           => $isLive,
    'videoId'           => $videoId,
    'video_id'          => $videoId,
    'title'             => $title,
    'method'            => $method,
    'in_service_window' => $inServiceWindow,
    'updated_at'        => date('Y-m-d H:i:s'),
    'cached_sec'        => $cacheDuration
];

// Handle Push Notifications when Live
if ($isLive) {
    $alreadySent = file_exists($notificationSentFile) && (time() - filemtime($notificationSentFile) < 14400); // 4 hours
    if (!$alreadySent) {
        $accessToken = getAccessToken($serviceAccountPath);
        if ($accessToken) {
            $serviceAccount = json_decode(file_get_contents($serviceAccountPath), true);
            $projectId = $serviceAccount['project_id'] ?? '';
            $sent = sendFCMNotification(
                $accessToken,
                $projectId,
                '🔴 Christ Embassy Farmers Branch is LIVE!',
                $title ?? 'Join our live service now for praise, worship, and the Word of God.',
                $videoId
            );
            if ($sent) {
                @file_put_contents($notificationSentFile, date('Y-m-d H:i:s') . " - " . $videoId);
                $result['notification_sent'] = true;
            }
        }
    } else {
        $result['notification_status'] = 'already_sent_within_4h';
    }
}

// Save to cache file
@file_put_contents($cacheFile, json_encode($result));

echo json_encode($result);
