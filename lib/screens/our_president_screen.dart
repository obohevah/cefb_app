import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';

class OurPresidentScreen extends StatelessWidget {
  const OurPresidentScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'OUR PRESIDENT',
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
                  'Our President',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"Whereof I was made a minister, according to the gift of the grace of God given unto me by the effectual working of his power."\n— Ephesians 3:7',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Portrait & Bio Container
          Container(
            color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF8F9FA),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Portrait
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/pastor_chris.jpg',
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 320,
                        color: const Color(0xFF8628E2).withOpacity(0.1),
                        child: const Icon(Icons.person, color: Color(0xFF8628E2), size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Text(
                    'Rev. Dr. Chris Oyakhilome DSc. DSc. DD.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'President of LoveWorld Inc. & Christ Embassy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFCC0000),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),

                  TranslatedText(
                    'Through an anointed ministry spanning over 30 years, Pastor, teacher, healing minister, '
                    'television host, and best-selling author Rev. Dr. Chris Oyakhilome DSc. DSc. DD. has helped '
                    'millions experience a victorious and purposeful life in God\'s word.\n\n'
                    'He is the author of the best-seller Rhapsody of Realities, the number one daily devotional around the world, '
                    'distributed in several thousand languages and billions of copies globally.\n\n'
                    'Presiding over an ever-widening network of LoveWorld television channels, ministry campuses, and digital '
                    'platforms, Pastor Chris brings the divine presence of God directly into homes across all seven continents.',
                    style: TextStyle(color: bodyColor, fontSize: 14, height: 1.65),
                  ),
                  const SizedBox(height: 24),

                  // Official links
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl('https://healingstreams.tv/'),
                        icon: const Icon(Icons.favorite, size: 16, color: Colors.white),
                        label: const Text('Healing Streams Live', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCC0000),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _launchUrl('https://pastorchrislive.org/'),
                        icon: const Icon(Icons.public, size: 16, color: Color(0xFF8628E2)),
                        label: const Text('Pastor Chris Live', style: TextStyle(color: Color(0xFF8628E2), fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF8628E2)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }
}
