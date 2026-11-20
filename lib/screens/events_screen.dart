import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';
import 'believe_god_screen.dart';
import 'new_here_screen.dart';
import 'first_steps_screen.dart';
import 'foundation_school_screen.dart';

/// Events Screen matching https://christembassyfarmersbranch.org/events/ verbatim.
/// Replicates the website's exact cards, images, badges, links, video player, and layout.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return ChurchScaffold(
      title: 'EVENTS',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/events/events_hero_bg.jpg'),
                fit: BoxFit.cover,
              ),
              color: const Color(0xFF161626),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'STAY UP TO DATE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFFD700),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "WITH WHAT'S HAPPENING AT CHRIST EMBASSY FARMERS BRANCH!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF2C3E50)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A00E0).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'EVENTS',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Events Grid / List ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildBelieveGodCard(context, isDark),
                            const SizedBox(height: 24),
                            _buildBaptismCard(context, isDark),
                            const SizedBox(height: 24),
                            _buildCommunionCard(context, isDark),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _buildWelcomePartyCard(context, isDark),
                            const SizedBox(height: 24),
                            _buildFoundationSchoolCard(context, isDark),
                            const SizedBox(height: 24),
                            _buildPraiseWorshipCard(context, isDark),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildBelieveGodCard(context, isDark),
                      const SizedBox(height: 24),
                      _buildWelcomePartyCard(context, isDark),
                      const SizedBox(height: 24),
                      _buildBaptismCard(context, isDark),
                      const SizedBox(height: 24),
                      _buildFoundationSchoolCard(context, isDark),
                      const SizedBox(height: 24),
                      _buildCommunionCard(context, isDark),
                      const SizedBox(height: 24),
                      _buildPraiseWorshipCard(context, isDark),
                    ],
                  ),
          ),

          const SizedBox(height: 36),

          // ── Bottom Invite Callout ("YOU'RE INVITED THIS SUNDAY!") ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/events/events_invite_bg.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "YOU'RE INVITED THIS SUNDAY!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TranslatedText(
                    'Join us Sundays @ 10:00 AM & Wednesdays @ 6:45 PM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => PlanVisitSheet.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31B23),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                      elevation: 4,
                    ),
                    child: const TranslatedText(
                      'PLAN YOUR VISIT NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),
          const ChurchFooter(),
        ],
      ),
    );
  }

  // ── 1. I Believe God Series ──
  Widget _buildBelieveGodCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: const _ResilientEventImage(
        assetPath: 'assets/images/events/believe_god_event.jpg',
        networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/482.jpg',
        height: 220,
      ),
      badgeTitle: 'I BELIEVE GOD SERIES',
      description: 'This month we will be starting an exciting series titled I believe God',
      buttonLabel: 'I Believe God Series',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BelieveGodScreen()),
        );
      },
    );
  }

  // ── 2. Welcome Party ──
  Widget _buildWelcomePartyCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: const _ResilientEventImage(
        assetPath: 'assets/images/events/welcome_party_event.jpeg',
        networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/41.jpeg',
        height: 220,
      ),
      badgeTitle: 'WELCOME PARTY',
      description:
          "Been new at Christ Embassy Farmer Branch the last few weeks? We'd love to have you at our Welcome Party!",
      buttonLabel: 'SIGN UP',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewHereScreen()),
        );
      },
    );
  }

  // ── 3. Baptism ──
  Widget _buildBaptismCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: const _ResilientEventImage(
        assetPath: 'assets/images/events/baptism_event.jpg',
        networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/35.jpg',
        height: 220,
      ),
      badgeTitle: 'BAPTISM',
      description:
          'Baptism gatherings are a special time to celebrate new life in Christ. We hold baptism Sundays once a quarter. You can sign up for the next Baptism Sunday below!',
      buttonLabel: 'SIGN UP',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FirstStepsScreen()),
        );
      },
    );
  }

  // ── 4. Foundation School ──
  Widget _buildFoundationSchoolCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: const _ResilientEventImage(
        assetPath: 'assets/images/events/foundation_school_event.jpeg',
        networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/06.jpeg',
        height: 220,
      ),
      badgeTitle: 'FOUNDATION SCHOOL',
      description:
          'Our Foundation School comprises of 7 classes taught over a 7 week period. The aim of the Foundation School is to educate on the foundational doctrines of Christ. Sign up for this class below!',
      buttonLabel: 'SIGN UP',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FoundationSchoolScreen()),
        );
      },
    );
  }

  // ── 5. Communion Service ──
  Widget _buildCommunionCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: Stack(
        children: [
          const _ResilientEventImage(
            assetPath: 'assets/images/events/communion_event.jpg',
            networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/45.jpg',
            height: 220,
          ),
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16162A).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white24, width: 0.8),
              ),
              child: Text(
                'EVERY FIRST SUNDAY OF THE MONTH',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
      badgeTitle: 'COMMUNION SERVICE',
      description:
          'Our Gloabl Communion Service with Pastor Chris is a service held every first Sunday of the month with our Founder/President, Rev. Chris Oyakhilome. This service is stream live to all our churches!',
      buttonLabel: 'PLAN YOUR VISIT NOW',
      onPressed: () => PlanVisitSheet.show(context),
    );
  }

  // ── 6. Praise & Worship (With Live Video Player) ──
  Widget _buildPraiseWorshipCard(BuildContext context, bool isDark) {
    return _EventCardBase(
      isDark: isDark,
      mediaWidget: const _EventVideoPlayer(
        assetPath: 'assets/videos/praise_worship_37.mp4',
        networkUrl: 'https://christembassyfarmersbranch.org/mt-content/uploads/2025/02/37.mp4',
        posterAsset: 'assets/images/events/praise_worship_poster.jpeg',
        height: 220,
      ),
      badgeTitle: 'PRAISE AND WORSHIP',
      description:
          'Praise is an extended time of heartfelt and effusive worship to God in an atmosphere of reverence.',
      buttonLabel: 'LoveWorld Worship',
      onPressed: () async {
        final uri = Uri.parse('https://ceflix.org/channel/2104/');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}

/// Base Card design matching the exact website structure
class _EventCardBase extends StatelessWidget {
  final bool isDark;
  final Widget mediaWidget;
  final String badgeTitle;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _EventCardBase({
    required this.isDark,
    required this.mediaWidget,
    required this.badgeTitle,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E32) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Media (Image or Video) ──
          mediaWidget,

          // ── Purple Gradient Title Badge ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B11FF), Color(0xFF4A00E0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              badgeTitle,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
          ),

          // ── Card Body (Description + Red Pill Button) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31B23),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 3,
                  ),
                  child: TranslatedText(
                    buttonLabel,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dual-fallback image component: local asset -> live website URL
class _ResilientEventImage extends StatelessWidget {
  final String assetPath;
  final String networkUrl;
  final double height;

  const _ResilientEventImage({
    required this.assetPath,
    required this.networkUrl,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => CachedNetworkImage(
          imageUrl: networkUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: Colors.black12,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: const Color(0xFF2E1A47),
            child: const Center(
              child: Icon(Icons.church, color: Colors.white38, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}

/// In-card video player for Praise & Worship (37.mp4)
class _EventVideoPlayer extends StatefulWidget {
  final String assetPath;
  final String networkUrl;
  final String posterAsset;
  final double height;

  const _EventVideoPlayer({
    required this.assetPath,
    required this.networkUrl,
    required this.posterAsset,
    required this.height,
  });

  @override
  State<_EventVideoPlayer> createState() => _EventVideoPlayerState();
}

class _EventVideoPlayerState extends State<_EventVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Try local asset first
      try {
        _videoController = VideoPlayerController.asset(widget.assetPath);
        await _videoController!.initialize();
      } catch (_) {
        // Fallback to website network URL
        _videoController?.dispose();
        _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.networkUrl));
        await _videoController!.initialize();
      }

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        showControls: true,
        placeholder: Image.asset(widget.posterAsset, fit: BoxFit.cover),
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFE31B23),
          handleColor: const Color(0xFFE31B23),
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white24,
        ),
      );

      setState(() => _initialized = true);
    } catch (e) {
      debugPrint('EventVideoPlayer init error: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Image.asset(widget.posterAsset, fit: BoxFit.cover),
      );
    }

    if (!_initialized || _chewieController == null) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(widget.posterAsset, fit: BoxFit.cover),
            Container(color: Colors.black38),
            const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Chewie(controller: _chewieController!),
    );
  }
}
