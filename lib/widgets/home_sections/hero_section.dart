import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';
import 'package:cefb_app/screens/new_here_screen.dart';

/// Clean Hero banner featuring background video, headline, and action buttons.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => HeroSectionState();
}

class HeroSectionState extends State<HeroSection> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/images/01.mp4');
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
      _controller!
        ..setLooping(true)
        ..setVolume(0.0)
        ..play();
    } catch (_) {
      // Fallback to static background
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeVideo();
    } else if (state == AppLifecycleState.paused) {
      pauseVideo();
    }
  }

  void pauseVideo() {
    if (_isInitialized && (_controller?.value.isPlaying ?? false)) {
      _controller?.pause();
    }
  }

  void resumeVideo() {
    if (_isInitialized && !(_controller?.value.isPlaying ?? true)) {
      _controller?.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isMobile ? 400 : 500,
      ),
      child: Stack(
        fit: StackFit.loose,
        children: [
          // Background Video or Fallback Container
          Positioned.fill(
            child: _isInitialized && _controller != null
                ? FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1A2E), Color(0xFF2D1B69)],
                      ),
                    ),
                  ),
          ),

          // Dark Overlay Gradient for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),

          // Hero Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20.0 : 40.0,
              vertical: 36.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // W E L C O M E   T O
                const TranslatedText(
                  'W E L C O M E   T O',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),

                // CHRIST EMBASSY
                TranslatedText(
                  'CHRIST EMBASSY',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: isMobile ? 32.0 : 44.0,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // FARMERS BRANCH
                TranslatedText(
                  'FARMERS BRANCH',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: isMobile ? 30.0 : 42.0,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tagline
                TranslatedText(
                  'GIVING YOUR LIFE A MEANING',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFFFD700),
                    fontSize: isMobile ? 12.0 : 15.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Service Times
                TranslatedText(
                  'SERVICE TIMES | SUNDAY @ 10 AM & WEDNESDAY @ 6:45 PM',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isMobile ? 12.0 : 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // Action Buttons: Plan Your Visit & I'm New Here
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => PlanVisitSheet.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31B23),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const TranslatedText(
                        'Plan Your Visit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NewHereScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const TranslatedText(
                        "I'm New Here",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
