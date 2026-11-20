import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';
import 'foundation_school_screen.dart';

class SalvationScreen extends StatelessWidget {
  const SalvationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return ChurchScaffold(
      title: 'PRAYER OF SALVATION',
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
                  'Salvation',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const TranslatedText(
                  'The Best Decision You Could Ever Make!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHY DID JESUS COME?',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'He Came To Give You Life',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                TranslatedText(
                  'Giving your life to Jesus changes everything. Jesus didn\'t come to judge you or condemn you! '
                  'He came to take away your burden, mend your broken heart, and give you eternal life, joy, and peace.\n\n'
                  'Romans 10:9 says: "If you declare with your mouth that Jesus is Lord, and believe in your heart that God raised him from the dead, you will be saved."',
                  style: TextStyle(color: bodyColor, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 24),

                // 4 Points
                _pointCard('1', 'All Have Sinned', 'Romans 3:23 — For all have sinned and fall short of the glory of God.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _pointCard('2', 'Sin Separates Us', 'Romans 6:23 — For the wages of sin is death, but the gift of God is eternal life through Jesus Christ.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _pointCard('3', 'Christ Died For Us', 'Romans 5:8 — But God demonstrates his own love for us in this: While we were still sinners, Christ died for us.', cardBg, textColor, bodyColor, isDark),
                const SizedBox(height: 12),
                _pointCard('4', 'Confession Saves You', 'Romans 10:10 — For with the heart man believeth unto righteousness; and with the mouth confession is made unto salvation.', cardBg, textColor, bodyColor, isDark),

                const SizedBox(height: 28),

                // Prayer Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8628E2), Color(0xFFCC0000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCC0000).withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PRAY THIS PRAYER OUT LOUD:',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFD4AF37),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '"O Lord God, I believe with all my heart in Jesus Christ, Son of the living God. '
                        'I believe He died for me and God raised Him from the dead. I believe He’s alive today. '
                        'I confess with my mouth that Jesus Christ is the Lord of my life from this day.\n\n'
                        'Through Him and in His Name, I have eternal life; I’m born again. Thank you Lord, for saving my soul! '
                        'I am now a child of God. Hallelujah!"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.7,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Text(
                  'DID YOU PRAY THAT PRAYER?',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFCC0000),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Congratulations! Welcome to the Family of God!',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TranslatedText(
                  'Let us know so we can send you a free copy of the book "Now That You Are Born Again" by Pastor Chris Oyakhilome.',
                  style: TextStyle(color: bodyColor, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 18),

                _SalvationForm(cardBg: cardBg, textColor: textColor, isDark: isDark),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoundationSchoolScreen())),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8628E2)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Next Step: Enroll in Foundation School', style: TextStyle(color: Color(0xFF8628E2), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }

  Widget _pointCard(
    String num,
    String title,
    String desc,
    Color cardBg,
    Color textColor,
    Color bodyColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFCC0000).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              num,
              style: GoogleFonts.montserrat(
                color: const Color(0xFFCC0000),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                TranslatedText(
                  desc,
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

class _SalvationForm extends StatefulWidget {
  final Color cardBg;
  final Color textColor;
  final bool isDark;

  const _SalvationForm({
    required this.cardBg,
    required this.textColor,
    required this.isDark,
  });

  @override
  State<_SalvationForm> createState() => _SalvationFormState();
}

class _SalvationFormState extends State<_SalvationForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF00B85C).withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF00B85C)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF00B85C), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Thank you! We celebrate your new life in Christ. Our pastoral team will be in touch with your welcome gift!',
                style: GoogleFonts.montserrat(color: widget.textColor, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final fieldBg = widget.isDark ? const Color(0xFF14142B) : const Color(0xFFF3F4F6);
    final borderColor = widget.isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _nameCtrl,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              hintText: 'Full Name',
              hintStyle: TextStyle(color: widget.isDark ? Colors.white38 : Colors.grey[500]),
              filled: true,
              fillColor: fieldBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            style: TextStyle(color: widget.textColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email Address',
              hintStyle: TextStyle(color: widget.isDark ? Colors.white38 : Colors.grey[500]),
              filled: true,
              fillColor: fieldBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            style: TextStyle(color: widget.textColor),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: TextStyle(color: widget.isDark ? Colors.white38 : Colors.grey[500]),
              filled: true,
              fillColor: fieldBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty || _emailCtrl.text.isNotEmpty) {
                  setState(() => _submitted = true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCC0000),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('I Prayed This Prayer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
