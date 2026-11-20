import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/popup_slide.dart';
import '../services/api_service.dart';

class PopupCarouselDialog extends StatefulWidget {
  final List<PopupSlide> slides;

  const PopupCarouselDialog({super.key, required this.slides});

  static Future<void> checkAndShow(BuildContext context) async {
    final slides = await ApiService.fetchPopups();
    if (slides.isEmpty || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PopupCarouselDialog(slides: slides),
    );
  }

  @override
  State<PopupCarouselDialog> createState() => _PopupCarouselDialogState();
}

class _PopupCarouselDialogState extends State<PopupCarouselDialog> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Slides
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.slides.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (context, index) {
                    final slide = widget.slides[index];
                    return CachedNetworkImage(
                      imageUrl: slide.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFFCC0000)),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Indicators
          if (widget.slides.length > 1) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.slides.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == i ? const Color(0xFFCC0000) : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
