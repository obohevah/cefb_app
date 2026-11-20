import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';

/// About Us Screen replicating https://christembassyfarmersbranch.org/about/ verbatim.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'ABOUT US',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
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
                  'About Us',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Giving your life a meaning',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFD4AF37),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => PlanVisitSheet.show(context),
                  icon: const Icon(Icons.calendar_today, size: 16, color: Colors.white),
                  label: const TranslatedText(
                    'Plan Your Visit',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31B23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),

          // Overview Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF8F9FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THIS IS LOVEWORLD',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Building a Happier World with Love!',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                TranslatedText(
                  'Christ Embassy Farmers Branch is a place where lives are given a meaning. We are a part of the global vision of Pastor Chris Oyakhilome and the LoveWorld Ministries. We have been serving the Carrollton metroplex since 2022.\n\n'
                  'When you worship with us at Christ Embassy Farmers Branch you learn more than just the letter of the word, you experience the ministry of the Holy Spirit. At Christ Embassy Farmers Branch, we take you on a journey through the word of God that enlightens and uplifts your spirit. We unravel to you the message of the Gospel and new creation realities in ways that you will easily comprehend.\n\n'
                  'Our Mission at Christ Embassy Farmers Branch is to bring all men to the place of their inheritance in Christ. Join us today!',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),

          // Section 1: Worship Services (with christ-embassy-dallas-150.png)
          _AboutFeatureCard(
            imagePath: 'assets/images/christ-embassy-dallas-150.png',
            tag: 'WORSHIP SERVICES',
            headline: 'Impactful Message, Sanctified Worship, Friendly People!',
            description:
                'Worship experience at Christ Embassy Farmers Branch is exhilarating with upbeat music that will stir your heart in holy worship and sanctified praise. At Christ Embassy Farmers Branch, you can expect to meet friendly people, smiling faces and helpful volunteers.',
            cardBg: cardBg,
            textColor: textColor,
            bodyColor: bodyColor,
          ),

          // Section 2: Cell Groups (with christ-embassy-dallas-151.png)
          _AboutFeatureCard(
            imagePath: 'assets/images/christ-embassy-dallas-151.png',
            tag: 'CELL GROUPS',
            headline: 'We Are Doing Life Together at Our Cell Groups!',
            description:
                "At Christ Embassy Farmers Branch, we are not just a church with cell groups, we are a cell group church. We believe you can't do life alone, that is why through a community of believers you can get plugged in and start doing life together with them.",
            cardBg: cardBg,
            textColor: textColor,
            bodyColor: bodyColor,
          ),

          // Section 3: Kiddies LoveWorld (with christ-embassy-dallas-152.png)
          _AboutFeatureCard(
            imagePath: 'assets/images/christ-embassy-dallas-152.png',
            tag: 'KIDDIES LOVEWORLD',
            headline: 'Teaching The Word in a Creative and Relevant Way!',
            description:
                'At Kiddies LoveWorld (KLW), children are not left out as we provide adequate care and effective learning environment for children of all ages. Every Sunday all children (babies through 6th grade) experience safe, age-appropriate environments where the Bible is taught in a creative and relevant way.',
            cardBg: cardBg,
            textColor: textColor,
            bodyColor: bodyColor,
          ),

          // Section 4: Teens Ministry (with christ-embassy-dallas-104.png)
          _AboutFeatureCard(
            imagePath: 'assets/images/christ-embassy-dallas-104.png',
            tag: 'TEENS LOVEWORLD',
            headline: 'Equipping Teens to Effect Change in Their World!',
            description:
                'The Teens Love World (TLW) at Christ Embassy Farmers Branch is our Teens Ministry. The mission of the TLW is to equip teenagers with the information, guidance and support they need to transition into successful adults who effect change in their world.',
            cardBg: cardBg,
            textColor: textColor,
            bodyColor: bodyColor,
          ),

          const SizedBox(height: 20),
          const ChurchFooter(),
        ],
      ),
    );
  }
}

class _AboutFeatureCard extends StatelessWidget {
  final String imagePath;
  final String tag;
  final String headline;
  final String description;
  final Color cardBg;
  final Color textColor;
  final Color bodyColor;

  const _AboutFeatureCard({
    required this.imagePath,
    required this.tag,
    required this.headline,
    required this.description,
    required this.cardBg,
    required this.textColor,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: const Color(0xFF8628E2).withValues(alpha: 0.1),
                child: const Icon(Icons.church, size: 48, color: Color(0xFF8628E2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headline,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TranslatedText(
                  description,
                  style: TextStyle(color: bodyColor, fontSize: 13, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
