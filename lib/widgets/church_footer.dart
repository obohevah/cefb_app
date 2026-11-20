import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'social_icons.dart';
import 'translated_text.dart';

class ChurchFooter extends StatelessWidget {
  const ChurchFooter({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0A0A14), Color(0xFF0F0F1E)]
              : const [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF352C7A)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          // Logo & Name
          Image.asset(
            'assets/images/03.png',
            height: 50,
            errorBuilder: (_, __, ___) => const Icon(Icons.church, color: Color(0xFFCC0000), size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            'CHRIST EMBASSY FARMERS BRANCH',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Giving your life a meaning',
            style: GoogleFonts.montserrat(
              color: const Color(0xFFD4AF37),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),

          // Service Times
          const TranslatedText(
            'Service Times',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const TranslatedText(
            'Sunday Service: 10:00 AM',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const TranslatedText(
            'Wednesday Midweek Service: 6:45 PM',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 24),

          // Location
          const TranslatedText(
            'Location',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '2445 Midway Rd #106, Carrollton, TX 75006',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _launchUrl('https://maps.google.com/?q=2445+Midway+Rd+%23106+Carrollton+TX+75006'),
            icon: const Icon(Icons.map_outlined, color: Color(0xFFD4AF37), size: 16),
            label: const TranslatedText(
              'Get Directions',
              style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD4AF37)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),

          const SizedBox(height: 24),

          // Contact
          const TranslatedText(
            'Contact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchUrl('tel:+16824145815'),
            child: const Text(
              '+1 (682) 414-5815',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _launchUrl('mailto:support@christembassyfarmersbranch.org'),
            child: const Text(
              'support@christembassyfarmersbranch.org',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          const SizedBox(height: 24),

          // Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialBtn(
                child: SocialIcons.facebook(size: 16),
                url: 'https://www.facebook.com/cefb1',
              ),
              const SizedBox(width: 14),
              _socialBtn(
                child: SocialIcons.instagram(size: 16),
                url: 'https://www.instagram.com/cefarmersbranch?igsh=MTdtdm84cWRlZHIyeA==',
              ),
              const SizedBox(width: 14),
              _socialBtn(
                child: SocialIcons.youtube(size: 14),
                url: 'https://www.youtube.com/@christembassyfarmersbranch',
              ),
              const SizedBox(width: 14),
              _socialBtn(
                child: SocialIcons.kingschat(size: 20),
                url: 'https://kingschat.online/user/farmersbranch',
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          Text(
            '© ${DateTime.now().year} Christ Embassy Farmers Branch. All Rights Reserved.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn({
    required Widget child,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
