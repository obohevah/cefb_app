import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';

/// Welcome Section: We don't judge, we value people.
class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Color(0xFF8628E2), size: 20),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B69) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TranslatedText(
                  'IN CHRIST EMBASSY',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF8628E2),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.favorite, color: Color(0xFF8628E2), size: 20),
            ],
          ),
          const SizedBox(height: 20),
          TranslatedText(
            'You can wear whatever you want and listen to life changing message from our Pastor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TranslatedText(
            "We don't judge. We value people.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8628E2),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TranslatedText(
            'This Sunday @ 10:00 AM or\nWednesday @ 6:45 PM',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFFE31B23),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
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
                'PLAN YOUR VISIT NOW',
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
}
