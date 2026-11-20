import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';

class NewHereScreen extends StatelessWidget {
  const NewHereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'NEW HERE',
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
                colors: [Color(0xFFFF8201), Color(0xFFEE0A78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Welcome Home',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const TranslatedText(
                  'We can’t wait to meet you this Sunday!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => PlanVisitSheet.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const TranslatedText(
                    'Plan Your Visit',
                    style: TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Church Welcome Banner Photo
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/13.jpeg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // What to Expect
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHAT TO EXPECT',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your First Experience',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                _expectCard(
                  icon: Icons.sentiment_satisfied_alt,
                  title: 'Friendly, Smiling Faces',
                  desc: 'From the parking lot to the sanctuary, our friendly hosts are ready to greet you, answer questions, and help you find a seat.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _expectCard(
                  icon: Icons.music_note,
                  title: 'Sanctified Praise & Holy Worship',
                  desc: 'Expect vibrant, uplifting worship that will stir your heart with thanksgiving and the glorious presence of God.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _expectCard(
                  icon: Icons.auto_stories,
                  title: 'Practical, Relevant Teaching',
                  desc: 'Pastor MJ delivers life-transforming biblical wisdom that equips you to overcome every challenge and live in continuous victory.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _expectCard(
                  icon: Icons.child_care,
                  title: 'Safe Kiddies Church',
                  desc: 'Your children (babies through 6th grade) will have an absolute blast in our safe, age-appropriate Kiddies LoveWorld ministry.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),

                const SizedBox(height: 32),
                Divider(color: isDark ? Colors.white12 : Colors.black12),
                const SizedBox(height: 24),

                // FAQs
                Text(
                  'FREQUENTLY ASKED QUESTIONS',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Got Questions? We’ve Got Answers',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _faqCard(
                  q: 'What should I wear?',
                  a: 'Come dressed in whatever you feel comfortable in! You’ll see people wearing suits, dresses, traditional African attire, or casual jeans and a shirt. We focus on the heart, not the attire.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _faqCard(
                  q: 'How long are the services?',
                  a: 'Our Sunday services are approximately 90 to 120 minutes packed with praise, worship, prayer, and life-changing ministry of the Word.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _faqCard(
                  q: 'Where do I park?',
                  a: 'We have ample free parking right on our church grounds at 13340 Marsh Ln, Farmers Branch, TX. Our parking team will be delighted to guide you to an open spot.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => PlanVisitSheet.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC0000),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const TranslatedText(
                      'Ready to Join Us? Plan Your Visit Today',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }

  Widget _expectCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color cardBg,
    required Color textColor,
    required Color bodyColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFCC0000), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                TranslatedText(
                  desc,
                  style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqCard({
    required String q,
    required String a,
    required Color cardBg,
    required Color textColor,
    required Color bodyColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06)),
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
              const Icon(Icons.help_outline, color: Color(0xFFCC0000), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  q,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TranslatedText(
            a,
            style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
