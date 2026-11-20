import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/pip_service.dart';
import '../services/livestream_service.dart';
import '../widgets/translated_text.dart';
import 'church_online_screen.dart';

class LivePlayerScreen extends StatefulWidget {
  final String? videoId;
  final String? title;
  final bool? isLive;

  const LivePlayerScreen({
    super.key,
    this.videoId,
    this.title,
    this.isLive,
  });

  @override
  State<LivePlayerScreen> createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPipCapable = false;
  late final bool _isLiveVideo;

  @override
  void initState() {
    super.initState();
    PipService.initialize();

    final activeId = (widget.videoId != null && widget.videoId!.isNotEmpty)
        ? widget.videoId!
        : (LiveStreamService.instance.liveStatus.value.videoId ?? 'Q_qUZoAYpgA');

    _isLiveVideo = widget.isLive ??
        (LiveStreamService.instance.liveStatus.value.isLive &&
            LiveStreamService.instance.liveStatus.value.videoId == activeId);

    _controller = YoutubePlayerController(
      initialVideoId: activeId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: _isLiveVideo,
        forceHD: true,
        enableCaption: false,
        hideControls: false,
      ),
    );

    // Check device capability
    PipService.isPipSupported().then((supported) {
      if (mounted) setState(() => _isPipCapable = supported);
    });

    // Enable auto-PiP when user presses home while watching (Android 12+)
    PipService.setAutoPipEnabled(true);
  }

  @override
  void dispose() {
    PipService.setAutoPipEnabled(false);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _enterPip() async {
    await PipService.enterPipMode(width: 16, height: 9);
  }

  void _openLiveChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChurchOnlineScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF7F7FA);
    final cardColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyTextColor = isDark ? Colors.white70 : const Color(0xFF4A5568);
    final borderColor = isDark ? Colors.white10 : const Color(0xFFE2E8F0);
    final appBarBg = isDark ? const Color(0xFF14142B) : const Color(0xFF8628E2);

    return ValueListenableBuilder<bool>(
      valueListenable: PipService.isInPipMode,
      builder: (context, inPip, _) {
        // When in Picture-in-Picture mode, display ONLY the video player
        // No scaffold, no app bar, no timers to prevent any Android ANR or UI freeze.
        if (inPip) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: false,
                bottomActions: const [],
                topActions: const [],
              ),
            ),
          );
        }

        // Full Screen presentation when returning or browsing normally
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: isDark ? 0 : 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text(
              _isLiveVideo ? 'Live Service' : 'Previous Service',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (_isPipCapable)
                IconButton(
                  icon: const Icon(Icons.picture_in_picture_alt, color: Color(0xFFD4AF37)),
                  tooltip: 'Picture-in-Picture (PiP)',
                  onPressed: _enterPip,
                ),
            ],
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Video Player Container
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: const Color(0xFFCC0000),
                    progressColors: const ProgressBarColors(
                      playedColor: Color(0xFFCC0000),
                      handleColor: Color(0xFFCC0000),
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),

                // Controls & Details under the player
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge & PiP button
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _isLiveVideo
                                  ? const Color(0xFFCC0000)
                                  : const Color(0xFF8628E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isLiveVideo
                                      ? Icons.fiber_manual_record
                                      : Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _isLiveVideo ? 'LIVE NOW' : 'PREVIOUS SERVICE',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (_isPipCapable)
                            OutlinedButton.icon(
                              onPressed: _enterPip,
                              icon: Icon(
                                Icons.picture_in_picture_alt,
                                size: 16,
                                color: isDark ? Colors.white : const Color(0xFF8628E2),
                              ),
                              label: TranslatedText(
                                'PiP Mode',
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF8628E2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? Colors.white38 : const Color(0xFF8628E2).withOpacity(0.5),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Service Title
                      Text(
                        widget.title ?? 'Christ Embassy Farmers Branch - Online Church Service',
                        style: GoogleFonts.montserrat(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'With Pastor MJ',
                        style: GoogleFonts.montserrat(
                          color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB45309),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Divider(color: borderColor),
                      const SizedBox(height: 16),

                      // Live Interactive Chat Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openLiveChat,
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: TranslatedText(
                            _isLiveVideo
                                ? 'Open Online Church Interactive Chat'
                                : 'Join Online Church Community',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Service Information Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Order',
                              style: GoogleFonts.montserrat(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TranslatedText(
                              '• Opening Prayer & Thanksgiving\n'
                              '• Holy Worship & Sanctified Praise\n'
                              '• The Word of God with Pastor MJ\n'
                              '• Tithes, Offerings & Blessings\n'
                              '• Special Announcements & Fellowship',
                              style: TextStyle(color: bodyTextColor, fontSize: 13, height: 1.6),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PiP Instructions Tip Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFFD4AF37).withOpacity(0.12)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFFD4AF37).withOpacity(0.3)
                                : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB45309),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TranslatedText(
                                'Tip: Press the PiP button above or press your phone\'s Home button to keep watching in a floating window while using other apps.',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : const Color(0xFF92400E),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Generous bottom padding to clear phone navigation bar
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
