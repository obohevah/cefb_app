/// Represents a banner/flyer popup shown on service days or special announcements
class PopupSlide {
  final int id;
  final String title;
  final String image;
  final int delay;
  final bool oncePerSession;

  const PopupSlide({
    required this.id,
    required this.title,
    required this.image,
    required this.delay,
    required this.oncePerSession,
  });

  /// Full image URL or asset path
  String get imageUrl {
    if (image.isEmpty) return 'assets/images/43.jpg';
    if (image.startsWith('http://') || image.startsWith('https://') || image.startsWith('assets/')) {
      return image;
    }
    final cleanPath = image.startsWith('/') ? image.substring(1) : image;
    return 'https://christembassyfarmersbranch.org/$cleanPath';
  }

  factory PopupSlide.fromJson(Map<String, dynamic> json) {
    final rawImg = (json['image'] ?? json['image_path'] ?? '').toString().trim();
    final onceRaw = json['oncePerSession'] ?? json['once_per_session'];
    final isOnce = onceRaw == true || onceRaw == 1 || onceRaw == '1' || onceRaw == 'true';

    return PopupSlide(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      image: rawImg,
      delay: json['delay'] is int ? json['delay'] : int.tryParse(json['delay'].toString()) ?? 1,
      oncePerSession: isOnce,
    );
  }
}
