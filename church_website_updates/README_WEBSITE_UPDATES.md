# Christ Embassy Farmers Branch - Website Livestream & Notification Speed Fixes

These files solve the 30-minute to 1-hour delay in live streaming and push notifications:

### 1. `auto_detect.php` (Upload to church website root)
- **Problem Before**: Used YouTube's Data API Search (`eventType=live`), which takes 15-45 minutes to index new streams, and had a rigid structure that waited on passive website visits.
- **Solution Now**: Checks YouTube's direct `/live` channel endpoint first (instant response in ~200ms when broadcasting), uses fast smart caching (30s), and triggers Firebase Cloud Messaging (FCM) push notifications immediately upon detecting live.
- **Instant Trigger Support**: You can pass `https://christembassyfarmersbranch.org/auto_detect.php?force=1` to force an immediate refresh without cache, or `?manual_id=YOUTUBE_VIDEO_ID` to manually specify a video id immediately!

### 2. `cron_live_check.php` (Upload to church website root)
- **Setup in cPanel**: Add a cron job that runs every 1 or 2 minutes:
  `curl -s https://christembassyfarmersbranch.org/cron_live_check.php > /dev/null 2>&1`
- **Result**: Even if NOBODY is browsing the website when service starts, the server detects the stream within 60 seconds and dispatches the push notifications to all church members' phones automatically.

### 3. `gallery_api.php` (Upload to church website root)
- Returns real-time albums and image URLs from MySQL (`gallery_albums` and `gallery_images`) in fast JSON format for the mobile app.

### 4. `livestreams/index.php` Patch
- Change Line 11 from:
  `$cacheTime = 3600; // 1 hour cache`
  to:
  `$cacheTime = 120; // 2 minutes cache`
- This makes new YouTube uploads and previous live streams show up in 2 minutes instead of 1 hour on the website!
