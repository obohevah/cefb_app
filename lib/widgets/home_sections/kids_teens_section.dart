import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';

/// Kids and Teens Ministry overview and check items.
class KidsTeensSection extends StatelessWidget {
  const KidsTeensSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E30) : const Color(0xFFF2F2F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Header Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Color(0xFF8628E2), size: 18),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B69) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TranslatedText(
                  'OUR KIDS & TEENS CHURCH',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF8628E2),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.favorite, color: Color(0xFF8628E2), size: 18),
            ],
          ),
          const SizedBox(height: 24),

          // Kids Church
          TranslatedText(
            'Our Kids Church has:',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckItem('Fun Services'),
          _buildCheckItem('Age Appropriate Bible Lessons'),
          _buildCheckItem('Nursery for babies (0-2 yrs)'),
          _buildCheckItem('Delicious Snacks'),
          _buildCheckItem('Creative Arts & Bible Games'),
          const SizedBox(height: 12),
          TranslatedText(
            "Kids love our kids church, and that's a fact! 😜",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF8628E2),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Divider(thickness: 1, height: 36),

          // Teens Church
          TranslatedText(
            'Our Teens Church offers:',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckItem('Authentic Worship'),
          _buildCheckItem('Relevant & Practical Teaching'),
          _buildCheckItem('Thriving Faith Community'),
          _buildCheckItem('Mentorship & Leadership Guidance'),
          _buildCheckItem('Inspiring Youth Events'),
          const SizedBox(height: 12),
          TranslatedText(
            'We equip our teenagers to be world changers! 🌟',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF8628E2),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => PlanVisitSheet.show(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31B23),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: const TranslatedText(
                'PLAN A VISIT NOW',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          Expanded(
            child: TranslatedText(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
