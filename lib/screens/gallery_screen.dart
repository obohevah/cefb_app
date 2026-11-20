import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import '../models/gallery_album.dart';
import '../services/api_service.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';

/// Church Gallery Screen replicating https://christembassyfarmersbranch.org/gallery/
/// Features real tabbed folder cards with 2x2 photo previews, vibrant gradients,
/// and smooth modal album popup with interactive lightbox.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Matured, dignified folder gradients maintaining each album's color identity
  static const List<List<Color>> _folderGradients = [
    [Color(0xFF2845AE), Color(0xFF182060)], // Album 8: Mike Wiggle (Matured Royal Navy -> Indigo)
    [Color(0xFF1976D2), Color(0xFF0D47A1)], // Album 1: Sunday Services (Matured Sapphire -> Deep Cobalt)
    [Color(0xFFA8235A), Color(0xFF6F0D39)], // Album 2: Baby Dedication (Matured Wine -> Velvet Rose)
    [Color(0xFF5E2390), Color(0xFF380860)], // Album 3: Special Celebrations (Matured Regal Imperial Violet)
    [Color(0xFFD35400), Color(0xFF962D00)], // Album 4: Night of Bliss (Matured Terracotta -> Deep Amber)
    [Color(0xFF1E7562), Color(0xFF0F4D40)], // Album 5: Foundation School (Matured Forest Teal -> Deep Emerald)
    [Color(0xFFB33939), Color(0xFF7A1D1D)], // Album 6: The Perfect Woman (Matured Crimson Maroon -> Burgundy)
    [Color(0xFF197F7A), Color(0xFF0C5450)], // Album 7: Children's Ministry (Matured Deep Ocean Spruce)
  ];

  void _openAlbumModal(BuildContext context, GalleryAlbum album, List<Color> gradient) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(dialogCtx).size.width;
        final screenHeight = MediaQuery.of(dialogCtx).size.height;
        final isLarge = screenWidth >= 700;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isLarge ? 40 : 16,
            vertical: isLarge ? 40 : 24,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: isLarge ? 900 : double.infinity,
            constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161626) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Modal Header (Gradient + Title + Close 'X' Button) ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          album.title,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: isLarge ? 18 : 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.of(dialogCtx).pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.close,
                            color: gradient.first,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Modal Body (Description + Photos Grid) ──
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (album.description.isNotEmpty) ...[
                          Text(
                            album.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : const Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                            thickness: 1.5,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Photos Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: album.images.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isLarge ? 3 : 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.15,
                          ),
                          itemBuilder: (context, photoIndex) {
                            final imgPath = album.images[photoIndex];
                            return _AlbumPhotoCard(
                              imagePath: imgPath,
                              isDark: isDark,
                              onTap: () {
                                _openFullScreenViewer(
                                  context: context,
                                  images: album.images,
                                  initialIndex: photoIndex,
                                  title: album.title,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openFullScreenViewer({
    required BuildContext context,
    required List<String> images,
    required int initialIndex,
    required String title,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(
          images: images,
          initialIndex: initialIndex,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return ChurchScaffold(
      currentIndex: 2,
      title: 'CHURCH GALLERY',
      showBackButton: true,
      body: FutureBuilder<List<GalleryAlbum>>(
        future: ApiService.fetchGallery(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE31B23)),
            );
          }

          final albums = snapshot.data ?? [];

          return Container(
            color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF8FAFC),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ── Gallery Header (Matching Website) ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'CHURCH GALLERY',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: isDark ? Colors.white : const Color(0xFF2D3748),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Text(
                          'Click on any folder below to explore our collection of beautiful moments and memories',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Folders Grid (Matching Website Layout) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: albums.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 3 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 28,
                      childAspectRatio: isDesktop ? 0.78 : 0.64,
                    ),
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      final gradient = _folderGradients[index % _folderGradients.length];
                      return _FolderCard(
                        album: album,
                        gradient: gradient,
                        isDark: isDark,
                        onTap: () => _openAlbumModal(context, album, gradient),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 36),

                // ── Bottom Hint (Matching Website) ──
                Center(
                  child: Text(
                    '↑ Click on any folder to open and view photos ↑',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : const Color(0xFF4A5568),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                const ChurchFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 3D Folder widget matching the website's .cefb-gal-folder-item
class _FolderCard extends StatelessWidget {
  final GalleryAlbum album;
  final List<Color> gradient;
  final bool isDark;
  final VoidCallback onTap;

  const _FolderCard({
    required this.album,
    required this.gradient,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Exactly 4 preview images for this specific album
    final previews = album.previewImages.length >= 4
        ? album.previewImages
        : (album.images.isNotEmpty ? album.images.take(4).toList() : <String>[]);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Folder Shape with Top Tab and 2x2 Photo Preview ──
          Expanded(
            flex: 6,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top folder tab
                Positioned(
                  top: -12,
                  left: 20,
                  child: Container(
                    width: 56,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE2E8F0),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                // Main folder colored body
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.85),
                      width: 3.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildPreviewSlot(previews.isNotEmpty ? previews[0] : null)),
                            const SizedBox(width: 5),
                            Expanded(child: _buildPreviewSlot(previews.length > 1 ? previews[1] : null)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildPreviewSlot(previews.length > 2 ? previews[2] : null)),
                            const SizedBox(width: 5),
                            Expanded(child: _buildPreviewSlot(previews.length > 3 ? previews[3] : null)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── White Folder Label Card Below ──
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E30) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    album.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.description.isNotEmpty
                        ? album.description
                        : '${album.images.length} Photos',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : const Color(0xFF4A5568),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSlot(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: 0.15), width: 0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: GalleryImage(
          path: path,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

/// Resilient image widget that tries local asset first and falls back to live website URL automatically
class GalleryImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const GalleryImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return Container(color: Colors.black12);
    }

    final filename = path.split('/').last;
    final assetPath = path.startsWith('assets/') ? path : 'assets/images/gallery/$filename';
    final networkUrl = path.startsWith('http')
        ? path
        : 'https://christembassyfarmersbranch.org/uploads/gallery/$filename';

    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return CachedNetworkImage(
          imageUrl: networkUrl,
          fit: fit,
          width: width,
          height: height,
          placeholder: (_, __) => Container(
            color: Colors.black12,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: Colors.black12,
            child: const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 24),
            ),
          ),
        );
      },
    );
  }
}

/// Single photo card in the album popup grid
class _AlbumPhotoCard extends StatelessWidget {
  final String imagePath;
  final bool isDark;
  final VoidCallback onTap;

  const _AlbumPhotoCard({
    required this.imagePath,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E30) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFF1F5F9),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GalleryImage(
            path: imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

/// Interactive Fullscreen Lightbox matching the website's .cefb-gal-lightbox
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
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${_currentIndex + 1} of ${widget.images.length}',
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 11),
            ),
          ],
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
