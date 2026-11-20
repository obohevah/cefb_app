import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';
import 'package:cefb_app/screens/live_player_screen.dart';
import 'package:cefb_app/screens/church_online_screen.dart';

/// Locations and Times section showcasing Physical and Online campus.
class LocationsTimesSection extends StatelessWidget {
  const LocationsTimesSection({super.key});

  Future<void> _openDirections() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=2445+Midway+Rd+%23106+Carrollton+TX+75006',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: TranslatedText(
            'LOCATIONS & TIMES',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),

        // Physical Campus Card
        _buildCampusCard(
          context: context,
          imagePath: 'assets/images/13.jpeg',
          title: 'CHRIST EMBASSY FARMERS BRANCH',
          subtitle: '2445 Midway Rd #106, Carrollton, TX 75006',
          serviceTimes: 'SUNDAYS 10:00 AM | WEDNESDAYS 6:45 PM',
          primaryBtnText: 'PLAN YOUR VISIT NOW',
          onPrimaryPressed: () => PlanVisitSheet.show(context),
          secondaryBtnText: 'GET DIRECTIONS',
          onSecondaryPressed: _openDirections,
        ),
        const SizedBox(height: 20),

        // Online Campus Card
        _buildCampusCard(
          context: context,
          imagePath: 'assets/images/17.jpeg',
          title: 'ONLINE CAMPUS',
          subtitle: 'YouTube Live | Facebook Live | Church Website',
          serviceTimes: 'SUNDAYS 10:00 AM | WEDNESDAYS 6:45 PM',
          primaryBtnText: 'WATCH LIVE ONLINE',
          onPrimaryPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LivePlayerScreen(isLive: true)),
            );
          },
          secondaryBtnText: 'OPEN CHURCH ONLINE & CHAT',
          secondaryBtnIcon: Icons.cell_tower,
          onSecondaryPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChurchOnlineScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCampusCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required String serviceTimes,
    required String primaryBtnText,
    required VoidCallback onPrimaryPressed,
    String? secondaryBtnText,
    IconData? secondaryBtnIcon,
    VoidCallback? onSecondaryPressed,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TranslatedText(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TranslatedText(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8628E2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TranslatedText(
                    serviceTimes,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF8628E2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31B23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: TranslatedText(
                      primaryBtnText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (secondaryBtnText != null && onSecondaryPressed != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onSecondaryPressed,
                      icon: Icon(secondaryBtnIcon ?? Icons.directions, size: 16),
                      label: TranslatedText(secondaryBtnText),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8628E2),
                        side: const BorderSide(color: Color(0xFF8628E2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
