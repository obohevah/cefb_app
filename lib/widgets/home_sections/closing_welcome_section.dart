import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';

/// Closing welcome message and heartfelt personal invitation.
class ClosingWelcomeSection extends StatelessWidget {
  const ClosingWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E30) : const Color(0xFFF2F2F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 24),
          TranslatedText(
            '🙌🏼 Come and embark on a life-transforming journey at Christ Embassy Farmers Branch. We can\'t wait to welcome you and experience God\'s love and power together! 🙌🏼',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          TranslatedText(
            'I promise you will like it here! 😃',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF8628E2),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 24),
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
