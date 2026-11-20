/// Represents a church message or service recording from YouTube
class VideoItem {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String publishedAt;
  final String? duration;

  const VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.publishedAt,
    this.duration,
  });

  factory VideoItem.fromYouTubeJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final idObj = json['id'] ?? {};
    final videoId = idObj is Map ? (idObj['videoId'] ?? '') : json['id'] ?? '';

    final thumbs = snippet['thumbnails'] ?? {};
    final highThumb = thumbs['high'] ?? thumbs['medium'] ?? thumbs['default'] ?? {};
    final thumbUrl = highThumb['url'] ?? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return VideoItem(
      id: videoId.toString(),
      title: snippet['title']?.toString() ?? 'Service Message',
      description: snippet['description']?.toString() ?? '',
      thumbnailUrl: thumbUrl.toString(),
      publishedAt: snippet['publishedAt']?.toString() ?? '',
      duration: json['contentDetails']?['duration']?.toString(),
    );
  }
}
