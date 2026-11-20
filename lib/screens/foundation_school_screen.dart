import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';

class FoundationSchoolScreen extends StatelessWidget {
  const FoundationSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'FOUNDATION SCHOOL',
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
                  'Foundation School',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '"Therefore leaving the principles of the doctrine of Christ, let us go on unto perfection..."\n— Hebrews 6:1-3',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIX-WEEK CURRICULUM',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rooted and Built Up In Him',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                TranslatedText(
                  'The aim of Foundation School is to educate new and maturing believers on the foundational '
                  'doctrines of Christ that are most surely believed among us at Christ Embassy. '
                  'Classes meet every Sunday at 9:00 AM CST in-person and online.',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 24),

                _classModule('Class 1', 'The New Creation', 'The regenerated human spirit, the soul and mind renewal, the origin of sin, remission vs. forgiveness, and living as a spirit being.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _classModule('Class 2', 'The Holy Spirit', 'Who the Holy Spirit is, His fellowship, speaking in tongues, the seven spirits of God, and the supernatural ministry of the believer.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _classModule('Class 3', 'Christian Doctrine', 'Foundations of water baptism, the resurrection of the dead, biblical prayer, fasting, and the Lord\'s Table (Communion).', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _classModule('Class 4', 'Evangelism & Cell Ministry', 'The Great Commission, corporate evangelism, soul-winning strategies, and the cell as a dynamic missionary unit.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _classModule('Class 5', 'Christian Character & Prosperity', 'Walking in love and forgiveness, biblical submission, the confession of faith, and divine principles of kingdom prosperity.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _classModule('Class 6', 'The Universal Church & Local Assembly', 'The Body of Christ, why every Christian must belong to a local assembly, our LoveWorld vision, and leadership graduation.', cardBg, textColor, bodyColor, isDark),

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
                    child: const Text(
                      'Enroll in Next Class — Register Online',
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

  Widget _classModule(
    String badge,
    String title,
    String desc,
    Color cardBg,
    Color textColor,
    Color bodyColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8628E2).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: GoogleFonts.montserrat(
                color: const Color(0xFF8628E2),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: 17,
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
    );
  }
}
