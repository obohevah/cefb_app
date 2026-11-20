import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';

class GiveScreen extends StatelessWidget {
  const GiveScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copy(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard: $text'),
        backgroundColor: const Color(0xFFE31B23),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChurchScaffold(
      currentIndex: 3,
      title: 'ONLINE GIVING',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                  'Online Giving',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"Let each one give as he has made up his own mind and purposed in his heart, '
                  'not reluctantly or sorrowfully or under compulsion, for God loves a cheerful giver."\n— 2 Corinthians 9:7',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WAYS TO GIVE',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFB8860B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Partner With The Gospel',
                  style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),

                // 1. Tithe.ly Card
                _tithelyCard(context, isDark),
                const SizedBox(height: 18),

                // 2. Zelle Card
                _zelleCard(context, isDark),
                const SizedBox(height: 18),

                // 3. CashApp Card
                _cashAppCard(context, isDark),
              ],
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }

  Widget _tithelyCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00C853).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF00C853),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.credit_card, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            'Tithe.ly Giving',
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Give your Tithes, Offerings, and Partnership seeds securely via card or bank.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF555555),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _launchUrl('https://tithe.ly/give_new/www/#/tithely/give-one-time/4f90b2c0-779c-4884-9daf-8544c94d57ce'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const TranslatedText(
                'Give via Tithe.ly Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _zelleCard(BuildContext context, bool isDark) {
    const email = 'give@christembassyfarmersbranch.org';
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8628E2).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF8628E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            'Zelle Giving',
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Send directly through your bank\'s Zelle to our church email address:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF555555),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8628E2).withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              email,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: const Color(0xFF8628E2),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _copy(context, email, 'Zelle Email'),
              icon: const Icon(Icons.copy, size: 16, color: Color(0xFF8628E2)),
              label: const TranslatedText(
                'Copy Zelle Email',
                style: TextStyle(color: Color(0xFF8628E2), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8628E2)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashAppCard(BuildContext context, bool isDark) {
    const cashtag = '\$give2cefarmersbranch';
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00D632).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF00D632),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            'CashApp Giving',
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Give easily via CashApp by sending to our church \$Cashtag:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF555555),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F0F1E) : const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00D632).withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              cashtag,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: const Color(0xFF00B22A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _copy(context, cashtag, 'CashApp Tag'),
              icon: const Icon(Icons.copy, size: 16, color: Color(0xFF00B22A)),
              label: const TranslatedText(
                'Copy \$Cashtag',
                style: TextStyle(color: Color(0xFF00B22A), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00B22A)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
