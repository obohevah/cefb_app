import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';

/// Pastor Section featuring Pastor MJ and pastoral greeting.
class PastorSection extends StatelessWidget {
  const PastorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8628E2), Color(0xFF5B2EC7), Color(0xFF352C7A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8628E2).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // White card with pastor photo
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/04.jpg',
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 260,
                        color: const Color(0xFF8628E2),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white30, size: 80),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: TranslatedText(
                    'PASTOR MJ OBOH',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF1A1A2E),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TranslatedText(
            "Thanks for stopping by! If you're searching for a church home, we're the place for you. We have options to plan your visit to participate online and in-person – whichever is best for you and your family.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          TranslatedText(
            "Whether you've never been to church before, or grew up attending weekly, plan your visit to join us this weekend!",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          TranslatedText(
            'We believe that God wants to do great things through you!',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFFFFD700),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
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
