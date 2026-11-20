import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';
import 'foundation_school_screen.dart';
import 'groups_screen.dart';
import 'salvation_screen.dart';
import 'contact_screen.dart';

class FirstStepsScreen extends StatelessWidget {
  const FirstStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'FIRST STEPS',
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
                  'First Steps',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const TranslatedText(
                  'Your Path to Spiritual Growth and Impact in God\'s Kingdom',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _stepCard(
                  step: 'STEP 1',
                  title: 'Salvation & New Creation',
                  desc: 'Surrender your life to Jesus Christ and receive the fullness of eternal life in your spirit.',
                  actionLabel: 'Pray the Salvation Prayer',
                  onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalvationScreen())),
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _stepCard(
                  step: 'STEP 2',
                  title: 'Foundation School',
                  desc: 'Gain deep understanding of the basic doctrines of Christ: the Holy Spirit, the New Creation, Christian Character, and Cell Ministry.',
                  actionLabel: 'Explore Foundation School',
                  onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoundationSchoolScreen())),
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _stepCard(
                  step: 'STEP 3',
                  title: 'Join a Cell Group',
                  desc: 'You were never meant to walk alone. Connect with brothers and sisters in your neighborhood for fellowship, Bible study, and mutual encouragement.',
                  actionLabel: 'Find a Cell Group',
                  onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GroupsScreen())),
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _stepCard(
                  step: 'STEP 4',
                  title: 'Serve in Ministry',
                  desc: 'Discover your gifts and make an eternal difference in Choir, Media/AV, Ushers, Children\'s Ministry, or Protocol.',
                  actionLabel: 'Contact Church Office',
                  onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen())),
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }

  Widget _stepCard({
    required String step,
    required String title,
    required String desc,
    required String actionLabel,
    required VoidCallback onAction,
    required Color cardBg,
    required Color textColor,
    required Color bodyColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              step,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TranslatedText(
            desc,
            style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCC0000)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: TranslatedText(
              actionLabel,
              style: const TextStyle(color: Color(0xFFCC0000), fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
