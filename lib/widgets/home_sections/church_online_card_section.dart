import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/church_online_screen.dart';
import '../translated_text.dart';

/// Homepage banner introducing the integrated Church Online platform
/// (cefblive.online.church) featuring live service countdown, public chat,
/// prayer requests, and sermon notes.
class ChurchOnlineCardSection extends StatelessWidget {
  const ChurchOnlineCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2A1647), const Color(0xFF130E26)]
              : [const Color(0xFF6B21A8), const Color(0xFF3B0764)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8628E2).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'CHURCH ONLINE',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, color: Color(0xFFFFD700), size: 12),
                    SizedBox(width: 4),
                    Text(
                      'Live Countdown',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Title
          Text(
            'Live Service Platform & Chat',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          const TranslatedText(
            'Connect with our global church family in real time. Features live service countdown, public & private prayer chat, sermon notes, and Bible.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChurchOnlineScreen()),
                );
              },
              icon: const Icon(Icons.cell_tower, color: Colors.white, size: 18),
              label: const TranslatedText(
                'Open Church Online Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31B23),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
