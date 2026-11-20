/// Represents the current live streaming state of the church
class LiveStreamStatus {
  final bool isLive;
  final String? videoId;
  final String? title;
  final String method;

  const LiveStreamStatus({
    required this.isLive,
    this.videoId,
    this.title,
    this.method = 'NONE',
  });

  factory LiveStreamStatus.offline() {
    return const LiveStreamStatus(
      isLive: false,
      videoId: null,
      title: null,
      method: 'NONE',
    );
  }

  factory LiveStreamStatus.fromJson(Map<String, dynamic> json) {
    final live = json['live'] == true || json['is_live'] == true;
    final vid = json['videoId'] ?? json['video_id'];
    final t = json['title'] ?? (live ? 'Christ Embassy Farmers Branch - Live Service' : null);
    final m = json['method']?.toString() ?? 'API';

    return LiveStreamStatus(
      isLive: live && vid != null && vid.toString().isNotEmpty,
      videoId: vid?.toString(),
      title: t?.toString(),
      method: m,
    );
  }
}
