import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/screens/gallery_screen.dart';

/// Gallery Preview Section with automatic periodic rotation.
/// Tapping anywhere navigates to the full Church Gallery page.
class GalleryPreviewSection extends StatefulWidget {
  const GalleryPreviewSection({super.key});

  @override
  State<GalleryPreviewSection> createState() => _GalleryPreviewSectionState();
}

class _GalleryPreviewSectionState extends State<GalleryPreviewSection>
    with SingleTickerProviderStateMixin {
  final List<String> _galleryImages = [
    'assets/images/08.jpeg',
    'assets/images/13.jpeg',
    'assets/images/12.jpeg',
    'assets/images/14.jpeg',
    'assets/images/15.jpeg',
    'assets/images/16.jpeg',
  ];

  int _currentIndex = 0;
  Timer? _autoRotateTimer;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Auto-rotate automatically without requiring user touch
    _autoRotateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _galleryImages.length;
      });
    });
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _floatController.dispose();
    super.dispose();
  }

  void _openGallery() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GalleryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openGallery,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4361EE), Color(0xFF3A0CA3), Color(0xFF2D1B69)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3A0CA3).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            TranslatedText(
              'CAPTURED MOMENTS &\nBLESSED MEMORIES',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.3,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),
            TranslatedText(
              'Step into our visual journey of faith, fellowship, and divine encounters',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openGallery,
              icon: const Icon(Icons.photo_library, size: 18),
              label: const TranslatedText('EXPLORE OUR GALLERY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4361EE),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 28),

            // Auto-rotating photo with subtle floating animation
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  key: ValueKey<int>(_currentIndex),
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _galleryImages[_currentIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
