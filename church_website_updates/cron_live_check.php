<?php
/**
 * Cron Job script for Christ Embassy Farmers Branch
 * Can be run every 1 or 2 minutes via cPanel / Linux Cron.
 *
 * Example cPanel Cron:
 * * * * * php -q /home/USER/public_html/cron_live_check.php > /dev/null 2>&1
 * or:
 * * * * * curl -s https://christembassyfarmersbranch.org/cron_live_check.php > /dev/null 2>&1
 */

date_default_timezone_set('America/Chicago');

$dayOfWeek = (int)date('w'); // 0 = Sunday, 3 = Wednesday
$hour = (int)date('G');       // 0 - 23
$minute = (int)date('i');
$timeVal = $hour * 60 + $minute;

// During Sunday (8:45 AM - 2:00 PM) and Wednesday (5:45 PM - 10:00 PM) CST:
// We actively check every minute to catch the live stream within seconds.
// Outside service hours, we check at most once every 15 minutes to save server CPU.
$isServiceTime = (
    ($dayOfWeek === 0 && $timeVal >= 525 && $timeVal <= 840) ||
    ($dayOfWeek === 3 && $timeVal >= 345 && $timeVal <= 600)
);

// If outside service hours and not on the 15-minute mark, skip execution
if (!$isServiceTime && ($minute % 15 !== 0)) {
    echo "Outside service hours (CST: " . date('D H:i') . "). Next periodic check at :15, :30, :45, :00.\n";
    exit(0);
}

// Call auto_detect.php (which uses 0-quota direct channel probe)
$autoDetectUrl = "https://christembassyfarmersbranch.org/auto_detect.php?force=1";

$ch = curl_init($autoDetectUrl);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT        => 15,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_USERAGENT      => 'CEFB-Cron/2.0'
]);
$res = curl_exec($ch);
curl_close($ch);

echo "Live check ran at " . date('Y-m-d H:i:s T') . "\n";
echo "Response: " . $res . "\n";
