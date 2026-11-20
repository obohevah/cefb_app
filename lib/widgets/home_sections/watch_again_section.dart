import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cefb_app/widgets/translated_text.dart';

/// Watch Again section allowing visitors to replay inspiring moments with direct video playback.
class WatchAgainSection extends StatefulWidget {
  final VoidCallback? onVideoStarted;
  final VoidCallback? onVideoStopped;

  const WatchAgainSection({
    super.key,
    this.onVideoStarted,
    this.onVideoStopped,
  });

  @override
  State<WatchAgainSection> createState() => _WatchAgainSectionState();
}

class _WatchAgainSectionState extends State<WatchAgainSection> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.asset('assets/images/101.mp4');
      await _videoPlayerController!.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        showControls: true,
        allowFullScreen: true,
        allowMuting: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF8628E2),
          handleColor: const Color(0xFF8628E2),
          bufferedColor: const Color(0xFF8628E2).withValues(alpha: 0.3),
          backgroundColor: Colors.white.withValues(alpha: 0.2),
        ),
      );

      setState(() => _isReady = true);
    } catch (e) {
      debugPrint('WatchAgainSection init caught: $e');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5B7FFF), Color(0xFF8628E2)],
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                TranslatedText(
                  'Watch Again',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Direct Video Area (No image overlay)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 220,
              child: _isReady && _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF8628E2)),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TranslatedText(
              'Revisit this inspiring moment anytime',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
