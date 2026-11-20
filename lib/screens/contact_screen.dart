import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';

/// Contact Us Screen replicating https://christembassyfarmersbranch.org/contact-us/
/// Features interactive Google Map navigation card, direct calls, emails, and working contact form.
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openGoogleMaps() async {
    const address = '2445+Midway+Rd+%23106+Carrollton+TX+75006';
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _submit(bool isDark) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    await ApiService.submitContactForm(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      message: _msgCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent! Our pastoral team will be in touch shortly.'),
        backgroundColor: Color(0xFFE31B23),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);
    final fieldBg = isDark ? const Color(0xFF14142B) : const Color(0xFFF3F4F6);
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return ChurchScaffold(
      title: 'CONTACT US',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Hero
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
                  'Contact Us',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const TranslatedText(
                  'We would love to hear from you!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Interactive Church Map Card
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
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
                  child: Column(
                    children: [
                      // Map View Banner
                      GestureDetector(
                        onTap: _openGoogleMaps,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/church_map.png',
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      color: Colors.black.withValues(alpha: 0.12),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE31B23),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.4),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.8),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Christ Embassy Farmers Branch',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.open_in_new, color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Open Map',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Navigation Actions
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _openGoogleMaps,
                                icon: const Icon(Icons.navigation, size: 16),
                                label: const Text('Get Directions'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE31B23),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _launchUrl('tel:+16824145815'),
                              icon: const Icon(Icons.phone, size: 16, color: Color(0xFF8628E2)),
                              label: const Text('Call Us', style: TextStyle(color: Color(0xFF8628E2))),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF8628E2)),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Info Cards Grid
                _infoTile(
                  Icons.location_on,
                  'Church Location',
                  '2445 Midway Rd #106, Carrollton, TX 75006',
                  cardBg,
                  textColor,
                  bodyColor,
                  isDark,
                  onTap: _openGoogleMaps,
                ),
                const SizedBox(height: 12),
                _infoTile(
                  Icons.phone,
                  'Call or Text Us',
                  '+1 (682) 414-5815',
                  cardBg,
                  textColor,
                  bodyColor,
                  isDark,
                  onTap: () => _launchUrl('tel:+16824145815'),
                ),
                const SizedBox(height: 12),
                _infoTile(
                  Icons.email,
                  'Email Support',
                  'support@christembassyfarmersbranch.org',
                  cardBg,
                  textColor,
                  bodyColor,
                  isDark,
                  onTap: () => _launchUrl('mailto:support@christembassyfarmersbranch.org'),
                ),
                const SizedBox(height: 12),
                _infoTile(
                  Icons.schedule,
                  'Service Times',
                  'Sunday Service: 10:00 AM CST\nWednesday Midweek Service: 6:45 PM CST',
                  cardBg,
                  textColor,
                  bodyColor,
                  isDark,
                ),

                const SizedBox(height: 28),

                // Contact Form
                Text(
                  'SEND US A MESSAGE',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE31B23),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'How Can We Help You?',
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),

                if (_submitted)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B85C).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF00B85C)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF00B85C), size: 32),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Thank you! Your message has been sent. Our team will contact you shortly.',
                            style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameCtrl,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Your Full Name',
                              labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                              filled: true,
                              fillColor: fieldBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                              filled: true,
                              fillColor: fieldBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            ),
                            validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _msgCtrl,
                            maxLines: 4,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              labelText: 'Message / Inquiries',
                              labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                              filled: true,
                              fillColor: fieldBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a message' : null,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : () => _submit(isDark),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE31B23),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const TranslatedText(
                                      'SEND MESSAGE',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.8),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const ChurchFooter(),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String desc,
    Color cardBg,
    Color textColor,
    Color bodyColor,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TranslatedText(
                    desc,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
