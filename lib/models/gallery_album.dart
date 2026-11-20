/// Represents an album in the church photo gallery matching https://christembassyfarmersbranch.org/gallery/
class GalleryAlbum {
  final int id;
  final String title;
  final String description;
  final String? coverImage;
  final List<String> previewImages;
  final List<String> images;

  const GalleryAlbum({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    required this.previewImages,
    required this.images,
  });

  static String normalizeUrl(String raw) {
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    if (raw.startsWith('../')) {
      return 'https://christembassyfarmersbranch.org/${raw.substring(3)}';
    }
    if (raw.startsWith('/')) {
      return 'https://christembassyfarmersbranch.org$raw';
    }
    return 'https://christembassyfarmersbranch.org/$raw';
  }

  factory GalleryAlbum.fromJson(Map<String, dynamic> json) {
    final rawImgs = json['images'];
    final List<String> imgList = [];
    if (rawImgs is List) {
      for (final item in rawImgs) {
        if (item != null && item.toString().isNotEmpty) {
          imgList.add(normalizeUrl(item.toString()));
        }
      }
    }

    final rawPreviews = json['previewImages'];
    final List<String> previewList = [];
    if (rawPreviews is List) {
      for (final item in rawPreviews) {
        if (item != null && item.toString().isNotEmpty) {
          previewList.add(normalizeUrl(item.toString()));
        }
      }
    } else if (imgList.isNotEmpty) {
      previewList.addAll(imgList.take(4));
    }

    final cover = json['coverImage'] != null
        ? normalizeUrl(json['coverImage'].toString())
        : (previewList.isNotEmpty ? previewList.first : (imgList.isNotEmpty ? imgList.first : null));

    return GalleryAlbum(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? 'Album',
      description: json['description']?.toString() ?? '',
      coverImage: cover,
      previewImages: previewList,
      images: imgList,
    );
  }
}
