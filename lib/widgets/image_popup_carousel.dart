import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cefb_app/models/popup_slide.dart';
import 'package:cefb_app/services/api_service.dart';

/// Image popup carousel — mirrors the website's event flyer popup:
/// Card with header "All Events / View All Events", left/right arrows,
/// page indicator ("1 / 3"), thumbnails strip, and close button.
/// Includes zero-overflow scrollable container with responsive flyer scaling.
class ImagePopupCarousel {
  /// Fetches popups from the church API and displays the carousel.
  static Future<void> fetchAndShow(BuildContext context) async {
    try {
      final slides = await ApiService.getPopupSlides();
      if (!context.mounted) return;

      final validSlides = slides.isNotEmpty ? slides : ApiService.defaultPopupSlides;

      await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.85),
        builder: (context) => ImagePopupCarouselDialog(slides: validSlides),
      );
    } catch (e) {
      debugPrint('ImagePopupCarousel.fetchAndShow caught: $e');
    }
  }
}

class ImagePopupCarouselDialog extends StatefulWidget {
  final List<PopupSlide> slides;

  const ImagePopupCarouselDialog({super.key, required this.slides});

  @override
  State<ImagePopupCarouselDialog> createState() =>
      _ImagePopupCarouselDialogState();
}

class _ImagePopupCarouselDialogState extends State<ImagePopupCarouselDialog> {
  int _currentIndex = 0;

  void _previousSlide() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _nextSlide() {
    if (_currentIndex < widget.slides.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _selectSlide(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    final currentSlide = slides[_currentIndex];
    final hasMultiple = slides.length > 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E30) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B4EE6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.photo_library, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSlide.title.isNotEmpty ? currentSlide.title : 'All Events',
                              style: GoogleFonts.montserrat(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'View All Events',
                              style: GoogleFonts.montserrat(
                                color: isDark ? Colors.white60 : Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Image Area with arrows and page indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.44,
                            minHeight: 200,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: currentSlide.imageUrl.startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: currentSlide.imageUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Container(
                                      color: isDark ? const Color(0xFF14142B) : Colors.grey.shade100,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFE31B23),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      'assets/images/43.jpg',
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Image.asset(
                                    currentSlide.imageUrl.isNotEmpty
                                        ? currentSlide.imageUrl
                                        : 'assets/images/43.jpg',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),

                        // Left Arrow
                        if (hasMultiple && _currentIndex > 0)
                          Positioned(
                            left: 8,
                            child: GestureDetector(
                              onTap: _previousSlide,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A2E), size: 22),
                              ),
                            ),
                          ),

                        // Right Arrow
                        if (hasMultiple && _currentIndex < slides.length - 1)
                          Positioned(
                            right: 8,
                            child: GestureDetector(
                              onTap: _nextSlide,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.chevron_right, color: Color(0xFF1A1A2E), size: 22),
                              ),
                            ),
                          ),

                        // Page counter badge (e.g. "1 / 3")
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentIndex + 1} / ${slides.length}',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Thumbnail strip below
                if (hasMultiple)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(slides.length, (index) {
                        final isSelected = index == _currentIndex;
                        final img = slides[index].imageUrl;
                        final isNet = img.startsWith('http');
                        return GestureDetector(
                          onTap: () => _selectSlide(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF6B4EE6) : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: isNet
                                  ? CachedNetworkImage(
                                      imageUrl: img,
                                      fit: BoxFit.cover,
                                      errorWidget: (c, u, e) => Image.asset(
                                        'assets/images/43.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      img.isNotEmpty ? img : 'assets/images/43.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                // Bottom Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: currentSlide.imageUrl));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image link copied to clipboard!')),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 15),
                          label: const Text('Copy Link', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            side: BorderSide(
                              color: isDark ? Colors.white24 : Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE31B23),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Close', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
