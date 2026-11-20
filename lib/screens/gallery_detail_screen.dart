import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import '../models/gallery_album.dart';
import '../widgets/translated_text.dart';

class GalleryDetailScreen extends StatelessWidget {
  final GalleryAlbum album;

  const GalleryDetailScreen({super.key, required this.album});

  void _openImageViewer(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(
          images: album.images,
          initialIndex: initialIndex,
          title: album.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          album.title,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
            ),
          ),
        ),
      ),
      body: album.images.isEmpty
          ? Center(
              child: TranslatedText(
                'No images in this album yet.',
                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: album.images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final rawPath = album.images[index];
                final filename = rawPath.split('/').last;
                final assetPath = rawPath.startsWith('assets/') ? rawPath : 'assets/images/gallery/$filename';
                final networkUrl = rawPath.startsWith('http')
                    ? rawPath
                    : 'https://christembassyfarmersbranch.org/uploads/gallery/$filename';

                return GestureDetector(
                  onTap: () => _openImageViewer(context, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CachedNetworkImage(
                        imageUrl: networkUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: isDark ? const Color(0xFF14142B) : Colors.grey.shade200,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: isDark ? const Color(0xFF1E1E38) : Colors.grey.shade300,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const _FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (context, index) {
          final rawPath = widget.images[index];
          final filename = rawPath.split('/').last;
          final assetPath = rawPath.startsWith('assets/') ? rawPath : 'assets/images/gallery/$filename';
          final networkUrl = rawPath.startsWith('http')
              ? rawPath
              : 'https://christembassyfarmersbranch.org/uploads/gallery/$filename';

          return PhotoView(
            imageProvider: AssetImage(assetPath),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3.0,
            errorBuilder: (context, error, stackTrace) {
              return PhotoView(
                imageProvider: CachedNetworkImageProvider(networkUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                errorBuilder: (context, error2, stackTrace2) {
                  return const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
