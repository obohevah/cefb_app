import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/screens/video_archive_screen.dart';
import 'package:cefb_app/screens/live_player_screen.dart';

/// Test Drive A Sermon section featuring carousel of past sermons.
class TestDriveSermonSection extends StatefulWidget {
  const TestDriveSermonSection({super.key});

  @override
  State<TestDriveSermonSection> createState() => _TestDriveSermonSectionState();
}

class _TestDriveSermonSectionState extends State<TestDriveSermonSection> {
  final List<Map<String, String>> _videos = [
    {
      'id': 'l-XqT0c1k9M',
      'title': 'MESSAGE TOPIC: THE FULLNESS OF JOY WITH PASTOR MJ',
    },
    {
      'id': '6_yFG5m28is',
      'title': 'LIKE A MEDICINE PART 1 WITH PASTOR MJ | JULY 23RD, 2025',
    },
    {
      'id': 'hvdDDfpkU4E',
      'title': 'MID-WEEK SERVICE WITH PASTOR MJ | JULY 30TH, 2025',
    },
  ];

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentPage < _videos.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Center(
            child: TranslatedText(
              'TEST DRIVE A SERMON',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),

        // Carousel of Sermons
        SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _videos.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  final videoId = video['id']!;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LivePlayerScreen(
                            videoId: videoId,
                            title: video['title'],
                            isLive: false,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: double.infinity,
                                    height: 160,
                                    color: Colors.black,
                                    child: const Icon(Icons.play_circle, color: Colors.white, size: 50),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE31B23),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TranslatedText(
                              video['title']!,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Left Arrow
              if (_currentPage > 0)
                Positioned(
                  left: 6,
                  child: GestureDetector(
                    onTap: _goToPrevious,
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
                      child: const Icon(Icons.chevron_left, color: Color(0xFF1A1A2E), size: 24),
                    ),
                  ),
                ),

              // Right Arrow
              if (_currentPage < _videos.length - 1)
                Positioned(
                  right: 6,
                  child: GestureDetector(
                    onTap: _goToNext,
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
                      child: const Icon(Icons.chevron_right, color: Color(0xFF1A1A2E), size: 24),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // View All Videos Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideoArchiveScreen()),
                );
              },
              icon: const Icon(Icons.video_library, size: 18),
              label: const TranslatedText('View Our Previous Videos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31B23),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
