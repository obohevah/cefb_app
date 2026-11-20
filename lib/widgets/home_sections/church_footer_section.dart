import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/widgets/plan_visit_sheet.dart';
import 'package:cefb_app/widgets/social_icons.dart';

/// Full Church Footer with working phone, email, map directions, and social media.
class ChurchFooterSection extends StatelessWidget {
  const ChurchFooterSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'support@christembassyfarmersbranch.org');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: '+16824145815');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=2445+Midway+Rd+%23106+Carrollton+TX+75006',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? const [Color(0xFF0A0A14), Color(0xFF0F0F1E)]
              : const [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF2C3E50)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Social
                Row(
                  children: [
                    Image.asset(
                      'assets/images/03.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _socialBtn(
                      child: SocialIcons.facebook(size: 16),
                      onTap: () => _launchUrl('https://www.facebook.com/cefb1'),
                    ),
                    const SizedBox(width: 12),
                    _socialBtn(
                      child: SocialIcons.instagram(size: 16),
                      onTap: () => _launchUrl(
                        'https://www.instagram.com/cefarmersbranch?igsh=MTdtdm84cWRlZHIyeA==',
                      ),
                    ),
                    const SizedBox(width: 12),
                    _socialBtn(
                      child: SocialIcons.youtube(size: 14),
                      onTap: () => _launchUrl(
                        'https://www.youtube.com/@christembassyfarmersbranch',
                      ),
                    ),
                    const SizedBox(width: 12),
                    _socialBtn(
                      child: SocialIcons.kingschat(size: 20),
                      onTap: () => _launchUrl('https://kingschat.online/user/farmersbranch'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Contact Info
                _contactRow(
                  label: 'Email Us',
                  value: 'support@christembassyfarmersbranch.org',
                  icon: Icons.email_outlined,
                  onTap: _launchEmail,
                ),
                const SizedBox(height: 14),
                _contactRow(
                  label: 'Call / Text Us',
                  value: '+1 (682) 414-5815',
                  icon: Icons.phone_outlined,
                  onTap: _launchPhone,
                ),
                const SizedBox(height: 14),
                _contactRow(
                  label: 'Visit Us',
                  value: '2445 Midway Rd #106, Carrollton, TX 75006',
                  icon: Icons.location_on_outlined,
                  onTap: _launchMaps,
                ),
                const SizedBox(height: 28),

                // Plan Visit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => PlanVisitSheet.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31B23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const TranslatedText(
                      'PLAN YOUR VISIT NOW',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),

          // Copyright
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Center(
              child: TranslatedText(
                '© 2026 Christ Embassy Farmers Branch. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _contactRow({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
