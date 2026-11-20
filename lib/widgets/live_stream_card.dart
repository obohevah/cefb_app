import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/livestream_status.dart';
import '../screens/live_player_screen.dart';
import '../screens/church_online_screen.dart';
import '../services/livestream_service.dart';
import 'translated_text.dart';

class LiveStreamCard extends StatelessWidget {
  const LiveStreamCard({super.key});

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChurchOnlineScreen()),
    );
  }

  void _openLivePlayer(BuildContext context, LiveStreamStatus status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LivePlayerScreen(
          videoId: status.videoId!,
          title: status.title,
          isLive: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<LiveStreamStatus>(
      valueListenable: LiveStreamService.instance.liveStatus,
      builder: (context, status, _) {
        if (!status.isLive || status.videoId == null) {
          return const SizedBox.shrink();
        }

        final videoId = status.videoId!;
        final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F122B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE31B23), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE31B23).withOpacity(0.25),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Live Status Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE31B23), Color(0xFF8628E2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fiber_manual_record, color: Color(0xFFE31B23), size: 10),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE NOW',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFE31B23),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Christ Embassy Farmers Branch',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                      tooltip: 'Open Live Chat',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _openChat(context),
                    ),
                  ],
                ),
              ),

              // Interactive Video Thumbnail Preview
              GestureDetector(
                onTap: () => _openLivePlayer(context, status),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(color: Color(0xFFE31B23)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black,
                          child: const Icon(Icons.live_tv, color: Colors.white54, size: 48),
                        ),
                      ),
                    ),
                    // Semi-transparent overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.65),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Large Pulsing Play Button
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31B23).withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE31B23).withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                    ),
                    // Bottom overlay badge
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.picture_in_picture_alt, color: Color(0xFFD4AF37), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'PiP Supported',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title & Watch Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.title ?? 'Christ Embassy Farmers Branch - Online Service',
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Live Broadcast with Pastor MJ',
                      style: GoogleFonts.montserrat(
                        color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB45309),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openLivePlayer(context, status),
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const TranslatedText(
                          'Watch Live Broadcast',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31B23),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

