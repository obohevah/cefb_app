import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/plan_visit_sheet.dart';
import '../widgets/translated_text.dart';

/// Kids Ministry Screen replicating https://christembassyfarmersbranch.org/kids/ verbatim.
class KidsScreen extends StatelessWidget {
  const KidsScreen({super.key});

  Future<void> _openLovetoons() async {
    final uri = Uri.parse('https://lovetoons.org/');
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
      title: "CHILDREN'S MINISTRY",
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
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
                  "WELCOME TO LOVEWORLD CHILDREN'S MINISTRY (LWCM)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const TranslatedText(
                  "Reaching Children from Birth to 12 Years with God's Word",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => PlanVisitSheet.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31B23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 3,
                  ),
                  child: const TranslatedText(
                    'PRE-REGISTER MY KIDS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Photo Banner
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/08.jpeg',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Introduction & Mission Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Loveworld Children’s Ministry reaches Children from Birth to 12years. We nurture and raise Children with the word of God to develop a personal loving, serving relationship with Jesus Christ and guide them to discover their divine purpose in God; giving them a sound spiritual and moral foundation for a vibrant and victorious Christian walk.\n\n'
                  'Children are very impressionable and need the wisdom of God and direction to navigate through the maze of the changes they will experience at different phases of development and growth.\n\n'
                  'The Children’s Ministry help provide the road map to safely navigate children by the guidance of the Holy Spirit as they transit to teen years.\n\n'
                  'You can save some time by pre-registering your child below.',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 28),

                // What's Best For Your Family Section
                Text(
                  "WHAT'S BEST FOR",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'YOUR FAMILY?',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TranslatedText(
                  "Whether you choose to experience Christ Embassy Farmers Branch online or in person, there's something for you!",
                  style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/08.jpeg',
                          height: 210,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/14.jpeg',
                          height: 210,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // In Person Card
                _OptionCard(
                  icon: Icons.location_on,
                  title: 'Attending In Person',
                  body:
                      'If you attend in person, our friendly VIP host will show you where our Kids Check-In is when you arrive. '
                      'We will meet your family, check your child into class, and answer any questions you may have. We can\'t wait to meet you!',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 12),

                // Online Card
                _OptionCard(
                  icon: Icons.wifi,
                  title: 'Attending Online',
                  body:
                      'If you attend online, you\'ll find that Christ Embassy Farmers Branch services are family friendly. '
                      'Your kids will love the spiritually uplifting worship, easy to understand preaching, and fun service elements. '
                      'Plus, find online resources for families via LoveToons below.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 16),

                // Online Resources button (lovetoons.org)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openLovetoons,
                    icon: const Icon(Icons.tv, color: Color(0xFF8628E2)),
                    label: const TranslatedText(
                      'ONLINE RESOURCES (LOVETOONS.ORG)',
                      style: TextStyle(
                        color: Color(0xFF8628E2),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8628E2), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // What We Teach Section
                Text(
                  'WHAT WE TEACH AT LWCM',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'YOUR KIDS WILL LOVE IT',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                TranslatedText(
                  'At Christ Embassy Farmers Branch, every child can grow in God\'s word in a delightful way. '
                  'Whether your kids attend online or in person, they\'ll experience an age appropriate lesson that will teach '
                  'them about God and His love for them. The teaching is interactive and utilizes multiple approaches for '
                  'different learning styles. We provide wholesome content and lesson take home activities for all age levels '
                  'ranging from Birth - 12 years. The goal at LoveWorld Children\'s Ministry & Schools is to raise bold and '
                  'courageous kids reaching out to their peers with the Gospel of Jesus Christ. And, they\'ll have a ton of fun!',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 28),

                // Bottom Callout Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PRE-REGISTER FOR LWCM',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFD4AF37),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const TranslatedText(
                        "We're raising bold and courageous kids reaching out to their peers with the Gospel of Jesus Christ!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () => PlanVisitSheet.show(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31B23),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const TranslatedText(
                          'PRE-REGISTER MY KIDS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const ChurchFooter(),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color cardBg;
  final Color textColor;
  final Color bodyColor;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.cardBg,
    required this.textColor,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8628E2).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8628E2), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                TranslatedText(
                  body,
                  style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
