import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

/// Video welcome popup — mirrors the website's videoPopup:
/// dark gradient overlay, header with red accent, muted autoplay video with
/// "tap to enable sound" overlay, and a clean close button.
class VideoWelcomePopup extends StatefulWidget {
  const VideoWelcomePopup({super.key});

  /// Displays the welcome video popup dialog.
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (context) => const VideoWelcomePopup(),
    );
  }

  @override
  State<VideoWelcomePopup> createState() => _VideoWelcomePopupState();
}

class _VideoWelcomePopupState extends State<VideoWelcomePopup> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _muted = true;
  bool _initialHintDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/101.mp4');
    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _controller!
        ..setLooping(true)
        ..setVolume(0)
        ..play();
    }).catchError((_) {
      // Graceful fallback if video fails to load
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleSound() {
    if (_controller == null || !_ready) return;
    setState(() {
      _muted = !_muted;
      _initialHintDismissed = true;
    });
    _controller!.setVolume(_muted ? 0.0 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF2D1B69)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildVideoArea(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 32, height: 3, color: const Color(0xFFE31B23)),
                const SizedBox(height: 8),
                Text(
                  'Welcome to Our',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Spiritual Journey',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Experience the transformative power of faith',
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: _toggleSound,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ready && _controller != null
                    ? VideoPlayer(_controller!)
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE31B23),
                          ),
                        ),
                      ),

                // Initial tap hint overlay (dismissed on first tap)
                if (!_initialHintDismissed)
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.volume_off_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap anywhere to enable sound',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Persistent Floating Speaker Button (always accessible to toggle mute/unmute anytime)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _toggleSound,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _muted
                              ? Colors.white.withValues(alpha: 0.3)
                              : const Color(0xFFE31B23),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _muted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: _muted ? Colors.white70 : Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _muted ? 'Sound Off' : 'Sound On',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: _ready ? 1.0 : null,
                minHeight: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFE31B23)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Ready to inspire',
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
