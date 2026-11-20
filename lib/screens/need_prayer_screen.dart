import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';

/// Prayer Request Screen replicating https://christembassyfarmersbranch.org/prayer/
/// Features Pastor MJ's photo, personal message, and direct submission to the church backend.
class NeedPrayerScreen extends StatefulWidget {
  const NeedPrayerScreen({super.key});

  @override
  State<NeedPrayerScreen> createState() => _NeedPrayerScreenState();
}

class _NeedPrayerScreenState extends State<NeedPrayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(bool isDark) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final res = await ApiService.submitPrayerRequest(
      firstName: _firstCtrl.text.trim(),
      lastName: _lastCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      prayerMessage: _msgCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Color(0xFFE31B23)),
            const SizedBox(width: 8),
            Text(
              'Prayer Received 🙏',
              style: GoogleFonts.montserrat(
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          res['status'] == 'success'
              ? 'Dear ${_firstCtrl.text.trim()}, Pastor MJ and our prayer team have received your request and are standing with you in prayer. "The Lord bless you and keep you" — Numbers 6:24'
              : (res['message'] ?? 'Thank you. Your prayer request has been received.'),
          style: GoogleFonts.montserrat(
            color: isDark ? Colors.white70 : const Color(0xFF444444),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _firstCtrl.clear();
              _lastCtrl.clear();
              _phoneCtrl.clear();
              _emailCtrl.clear();
              _msgCtrl.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31B23),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Amen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
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
      title: 'NEED PRAYER',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
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
                  'How can I pray for you?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const TranslatedText(
                  'You are not alone, we will pray for you personally',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pastor MJ Introduction Card with Photo
                Container(
                  padding: const EdgeInsets.all(18),
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/pastor_mj.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 100,
                                color: const Color(0xFF8628E2),
                                child: const Icon(Icons.person, color: Colors.white, size: 50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pastor Mike Jazziel Oboh',
                                  style: GoogleFonts.montserrat(
                                    color: textColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Pastor MJ — Christ Embassy FB',
                                  style: TextStyle(
                                    color: Color(0xFFE31B23),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '📞 +1 (682) 414-5815\n✉️ support@cefarmersbranch.org',
                                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : const Color(0xFFF9F9FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          "\"Hello there! My name is Mike Jazziel Oboh, and I’m a pastor at Christ Embassy Farmers Branch.\n\n"
                          "As a pastor, I know that life can feel overwhelming sometimes. But I want you to know you're not alone and I'm here to pray for you.\n\n"
                          "If you want prayer, just message me directly below. No matter what, I promise I will pray for you. And it can't hurt to have a pastor praying for you, right? 😊\"\n\n"
                          "🙏 - Pastor MJ",
                          style: TextStyle(
                            color: bodyColor,
                            fontSize: 13,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Prayer Request Form
                Container(
                  padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SEND YOUR PRAYER REQUEST',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFE31B23),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We Will Pray For You Personally',
                          style: GoogleFonts.montserrat(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // First & Last Name
                        Text(
                          "Hi, I'm Pastor Mike Jazziel, what is your name?",
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstCtrl,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                                  filled: true,
                                  fillColor: fieldBg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _lastCtrl,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                                  filled: true,
                                  fillColor: fieldBg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mobile Number
                        Text(
                          "What's the best mobile number to reach you?",
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Cell Phone Number',
                            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                            labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                            filled: true,
                            fillColor: fieldBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Phone number is required' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email Address
                        Text(
                          'What email address can we use to contact you?',
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                            filled: true,
                            fillColor: fieldBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                          ),
                          validator: (v) => v == null || !v.contains('@') ? 'Valid email is required' : null,
                        ),
                        const SizedBox(height: 16),

                        // Prayer Message
                        Text(
                          'How can we pray for you today?',
                          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _msgCtrl,
                          maxLines: 5,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Share what is on your heart. Everything shared is treated with complete pastoral confidentiality...',
                            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 13),
                            filled: true,
                            fillColor: fieldBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your prayer request' : null,
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
                              elevation: 3,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const TranslatedText(
                                    'SUBMIT PRAYER REQUEST',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.8),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'By submitting, you agree to receive pastoral prayer communications from CHRIST EMBASSY FARMERS BRANCH.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
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
}
