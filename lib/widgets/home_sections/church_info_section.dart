import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';

/// Church info banner detailing mission and service hours.
class ChurchInfoSection extends StatelessWidget {
  const ChurchInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8628E2), Color(0xFF4A1D8C), Color(0xFF2D3A5E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8628E2).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TranslatedText(
            'A BIBLE BASED, SPIRIT-FILLED CHURCH IN CARROLLTON, TEXAS',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.3,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),
          TranslatedText(
            'SUNDAYS AT 10:00 AM  |  WEDNESDAYS AT 6:45 PM',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TranslatedText(
              'IN-PERSON & ONLINE',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: const Color(0xFFFFD700),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
