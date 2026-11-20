import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';

class OurBeliefsScreen extends StatelessWidget {
  const OurBeliefsScreen({super.key});

  static const List<_BeliefItem> _beliefs = [
    _BeliefItem(
      title: "The Bible",
      body: "We believe that the Bible contains the inspired and infallible Word of God.",
      scripture: "2 Timothy 3:16; 2 Peter 1:20-21",
    ),
    _BeliefItem(
      title: "The Trinity",
      body: "We believe that there is only one God eternally existent in three persons: God the Father, God the Son, and God the Holy Ghost.",
      scripture: "Ephesians 4:5-6; Genesis 1:26; Matthew 3:16-17",
    ),
    _BeliefItem(
      title: "Christ's Deity",
      body: "We believe in the deity of Christ; He was born of a virgin; He was conceived of the Holy Ghost; He died; He rose again from the dead bodily; He ascended into heaven bodily.",
      scripture: "John 1:1-4; John 10:30; Hebrews 1:1-5; Matthew 1:18-25; Luke 1:30-35; John 20:25-29",
    ),
    _BeliefItem(
      title: "The Rapture",
      body: "We believe in the rapture of the church and the glorious Second Coming of Christ.",
      scripture: "1 Thessalonians 4:16-17; Matthew 24:29-30",
    ),
    _BeliefItem(
      title: "Repentance",
      body: "We believe that the only means of being cleansed from sin is repentance and faith in the precious blood of Jesus.",
      scripture: "Acts 3:19; Luke 24:47; Ephesians 1:7",
    ),
    _BeliefItem(
      title: "Regeneration",
      body: "We believe regeneration by the power of the Holy Spirit through the Word of God is essential for personal salvation.",
      scripture: "Titus 2:5; John 3:3-5; Ephesians 5:25-27",
    ),
    _BeliefItem(
      title: "Redemption & Healing",
      body: "We believe that the redemptive work of Christ on the cross provides divine healing for the body and salvation for the soul of everyone that believes.",
      scripture: "1 Peter 2:24; Acts 3:16; Acts 9:32-35",
    ),
    _BeliefItem(
      title: "The Holy Spirit",
      body: "We believe that when an individual receives the Holy Ghost, he receives divine enablement and power for Christian service and witness.",
      scripture: "Acts 1:8; Acts 2:4; Acts 4:5-12",
    ),
    _BeliefItem(
      title: "Sanctification",
      body: "We believe in the sanctifying power of the Holy Ghost that enables the believer to live a holy and consecrated life.",
      scripture: "Romans 15:16; 1 Corinthians 6:11",
    ),
    _BeliefItem(
      title: "The Resurrection",
      body: "We believe in the final resurrection of both the saved and the lost; the former to eternal life and the latter to eternal judgment.",
      scripture: "Revelation 20:11-15; 1 Corinthians 15:12-23",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'WHAT WE BELIEVE',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'What We Believe',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"Forasmuch as many have taken in hand to set forth in order a declaration of those things which are most surely believed among us..."\n— Luke 1:1',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Intro
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF8F9FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATEMENT OF BIBLE DOCTRINE',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Foundational Truths of Christ',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                TranslatedText(
                  "This is the statement of Bible doctrine as believed and taught by the Believers' LoveWorld Inc. aka Christ Embassy. "
                  "This statement of faith has its source in the inspired Word of God and is in total agreement with the foundational "
                  "principles of the doctrines of Christ.",
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),

          // Belief Cards List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                for (int i = 0; i < _beliefs.length; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: (i % 2 == 0 ? const Color(0xFFCC0000) : const Color(0xFF8628E2)).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.montserrat(
                                  color: i % 2 == 0 ? const Color(0xFFCC0000) : const Color(0xFF8628E2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _beliefs[i].title,
                                style: GoogleFonts.montserrat(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TranslatedText(
                          _beliefs[i].body,
                          style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F2F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bookmark_border, size: 14, color: Color(0xFFCC0000)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _beliefs[i].scripture,
                                  style: GoogleFonts.montserrat(
                                    color: isDark ? Colors.white70 : const Color(0xFF555555),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Plan visit CTA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => PlanVisitSheet.show(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Join Us This Sunday — Plan Your Visit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }
}

class _BeliefItem {
  final String title;
  final String body;
  final String scripture;

  const _BeliefItem({
    required this.title,
    required this.body,
    required this.scripture,
  });
}
