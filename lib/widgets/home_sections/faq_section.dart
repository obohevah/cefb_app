import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';

/// FAQ Accordion Section with smooth wave styling.
class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I participate digitally?',
      'answer':
          'If you choose to participate in Christ Embassy Farmers Branch services digitally, all you need is a smartphone, computer, or smart TV! Pull up our services Live on Facebook, YouTube or our Website on Sunday mornings or Wednesday evenings and engage and connect with others in the comments.',
    },
    {
      'question': 'What time is service online and in-person?',
      'answer':
          'Services at Christ Embassy Farmers Branch are on Sundays at 10:00 AM and Wednesdays at 6:45 PM. The time is the same whether you choose to join us online or in-person! Our services run for about 2 hours except on the first Sunday of the month when we have a Global Communion Service with Pastor Chris Oyakhilome.',
    },
    {
      'question': 'How do I join an online or in-person community?',
      'answer':
          'There is a place for you in an online or in-person group. Small Groups are an easy place to belong and meet lifelong friends. Visit our Groups page to get connected!',
    },
    {
      'question': 'What are your services like?',
      'answer':
          'Our services are spiritually uplifting with contemporary praise and worship, prayer, devotional reading from Rhapsody of Realities, and inspiring teaching from God\'s Word.',
    },
    {
      'question': 'Am I expected to participate in the offering?',
      'answer':
          'No! We want our service to be a gift to you as our guest. Please do not feel any obligation to participate in the offering.',
    },
    {
      'question': 'Where do I participate in-person?',
      'answer':
          'Our campus is located at 2445 Midway Rd #106, Carrollton, TX 75006.',
    },
    {
      'question': 'Is there something for my kids?',
      'answer':
          'Yes! Nursery is provided for children 2 years and under, and safe, vibrant classes are available for kids up to 12 years.',
    },
    {
      'question': 'Do you have a Teens Church?',
      'answer':
          'Yes, we have an exciting Teens Church! Our friendly greeters will gladly guide teenagers to the Teens Church.',
    },
    {
      'question': 'Where do I park?',
      'answer':
          'We have VIP reserved parking spaces right in front for our first-time guests. Just flash your hazard blinkers and our parking team will direct you!',
    },
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF2C3E50)],
        ),
      ),
      child: Column(
        children: [
          _buildWave(isTop: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                const TranslatedText(
                  'JOINING ONLINE OR IN-PERSON?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                TranslatedText(
                  'FAQ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                TranslatedText(
                  'Have questions? We have the answers!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                ...List.generate(_faqItems.length, (index) => _buildFAQItem(index)),
              ],
            ),
          ),
          _buildWave(isTop: false),
        ],
      ),
    );
  }

  Widget _buildWave({required bool isTop}) {
    return CustomPaint(
      size: const Size(double.infinity, 50),
      painter: _WavePainter(isTop: isTop),
    );
  }

  Widget _buildFAQItem(int index) {
    final item = _faqItems[index];
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isExpanded ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TranslatedText(
                      item['question']!,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TranslatedText(
                item['answer']!,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final bool isTop;

  _WavePainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF2C3E50)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    if (isTop) {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height * 0.3);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.2,
        size.width,
        size.height * 0.5,
      );
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height * 0.5);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.2,
        size.width * 0.5,
        size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.6,
        size.width,
        size.height * 0.3,
      );
      path.lineTo(size.width, 0);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
