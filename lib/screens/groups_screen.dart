import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';
import 'contact_screen.dart';

/// Small Groups Screen replicating https://christembassyfarmersbranch.org/groups/ verbatim.
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'SMALL GROUPS',
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
                  'Small Group',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "...Because you can't do life alone!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFD4AF37),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Photo Banner
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
              'assets/images/12.jpeg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Life is Better Connected Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONNECT WITH US',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Life is Better Connected',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                TranslatedText(
                  'Small Groups are the best place to truly experience the church family. '
                  'It’s where you will connect and be known, study the Bible, pray for one another, reach out to others '
                  'and make lifelong friends. For many, the Small Group is a safe place to step into the life of a local church, '
                  'whether you are new to church and have questions or looking for a new church to call home.\n\n'
                  'Our Small Groups are made up of men and women from all generations of life, these groups meet throughout the week '
                  'for fellowship, care, prayer, accountability, sharing stories and studying God’s Word. '
                  'They’re a place where we work to consider each other over ourselves.',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 28),

                // FAQs Section
                Text(
                  'FREQUENTLY ASKED QUESTIONS',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Common Questions About Small Groups',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                _FaqAccordion(
                  question: 'Why should I join a Small Group?',
                  answer:
                      'We believe you can’t do life by yourself. That’s why the bible says he places the solitary in families (Psalm 68:6). '
                      'God designed us to be connected to each other so that we can continue to grow in every area of our lives.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 10),
                _FaqAccordion(
                  question: 'What types of groups are there?',
                  answer:
                      'We have groups for Women, Men, Married, Singles, Couples, Teens, College & Career, Co-ed. '
                      'These are broken down by location, meeting day and time.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 10),
                _FaqAccordion(
                  question: 'Is Childcare Provided?',
                  answer:
                      'Not all Groups offer childcare, but there are options available. Make sure to let us know if you would like to join a group with childcare. '
                      'Some groups will have participants share responsibility in watching the children, split the cost for a sitter, or make other arrangements.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 10),
                _FaqAccordion(
                  question: 'How often do Groups meet?',
                  answer:
                      'Groups meet on different days and times throughout the week. Our Group search page has details on the day, time, and how often each Group meets.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 10),
                _FaqAccordion(
                  question: 'Where do Groups meet?',
                  answer:
                      'Groups meet in homes, restaurants, and tea shops. We will help you find a Group near you based on the zip code when you sign up.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),
                const SizedBox(height: 10),
                _FaqAccordion(
                  question: 'What will my Group study?',
                  answer:
                      'Study outlines are provided by the ministry on a monthly basis and all Cell Groups are supposed to adhere to the same bible study outline.',
                  cardBg: cardBg,
                  textColor: textColor,
                  bodyColor: bodyColor,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactScreen()),
                    ),
                    icon: const Icon(Icons.group_add, color: Colors.white),
                    label: const TranslatedText(
                      'Sign Up for a Small Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31B23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
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

class _FaqAccordion extends StatelessWidget {
  final String question;
  final String answer;
  final Color cardBg;
  final Color textColor;
  final Color bodyColor;

  const _FaqAccordion({
    required this.question,
    required this.answer,
    required this.cardBg,
    required this.textColor,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            question,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconColor: const Color(0xFF8628E2),
          collapsedIconColor: textColor.withValues(alpha: 0.6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            TranslatedText(
              answer,
              style: TextStyle(
                color: bodyColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
