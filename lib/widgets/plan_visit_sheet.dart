import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../services/api_service.dart';
import 'translated_text.dart';

class PlanVisitSheet extends StatefulWidget {
  const PlanVisitSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PlanVisitSheet(),
    );
  }

  @override
  State<PlanVisitSheet> createState() => _PlanVisitSheetState();
}

class _PlanVisitSheetState extends State<PlanVisitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _videoReady = false;

  String _selectedService = 'Sunday Service - 10:00 AM';
  DateTime _visitDate = DateTime.now().add(const Duration(days: 1));
  bool _isSubmitting = false;

  final List<Map<String, String>> _children = [];

  @override
  void initState() {
    super.initState();
    _initIntroVideo();
  }

  Future<void> _initIntroVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.asset('assets/images/101.mp4');
      await _videoPlayerController!.initialize();
      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFCC0000),
          handleColor: const Color(0xFFCC0000),
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white24,
        ),
      );

      setState(() => _videoReady = true);
    } catch (e) {
      debugPrint('PlanVisitSheet video init caught: $e');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _addChild() {
    setState(() {
      _children.add({
        'firstName': '',
        'lastName': '',
        'dob': '2020-01-01',
        'notes': '',
      });
    });
  }

  Future<void> _submit(bool isDark) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final dateStr =
        '${_visitDate.year}-${_visitDate.month.toString().padLeft(2, '0')}-${_visitDate.day.toString().padLeft(2, '0')}';

    final res = await ApiService.submitPlanVisit(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      visitDate: dateStr,
      selectedService: _selectedService,
      children: _children,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Navigator.pop(context); // Close sheet

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          res['status'] == 'success' ? 'Visit Confirmed! 🎉' : 'Submission Received',
          style: GoogleFonts.montserrat(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          res['status'] == 'success'
              ? 'We are delighted to welcome you to Christ Embassy Farmers Branch! Our VIP team is preparing for your visit.'
              : (res['message'] ?? 'Thank you! We look forward to meeting you.'),
          style: GoogleFonts.montserrat(
            color: isDark ? Colors.white70 : const Color(0xFF444444),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCC0000),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF14142B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF555555);
    final fieldBg = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF3F4F6);
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: bottomInset > 0 ? bottomInset + 16 : (bottomPadding > 0 ? bottomPadding + 20 : 28),
      ),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Plan Your Visit',
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: bodyColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              TranslatedText(
                'Let us know you are coming so we can prepare a warm welcome for you!',
                style: TextStyle(color: bodyColor, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // ── Introductory Video ──
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _videoReady && _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: CircularProgressIndicator(color: Color(0xFFCC0000)),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Names
              Row(
                children: [
                  Expanded(
                    child: _input(
                      controller: _firstNameCtrl,
                      label: 'First Name',
                      textColor: textColor,
                      fieldBg: fieldBg,
                      borderColor: borderColor,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _input(
                      controller: _lastNameCtrl,
                      label: 'Last Name',
                      textColor: textColor,
                      fieldBg: fieldBg,
                      borderColor: borderColor,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _input(
                controller: _phoneCtrl,
                label: 'Phone Number',
                textColor: textColor,
                fieldBg: fieldBg,
                borderColor: borderColor,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              _input(
                controller: _emailCtrl,
                label: 'Email Address',
                textColor: textColor,
                fieldBg: fieldBg,
                borderColor: borderColor,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.contains('@') ? null : 'Valid email required',
              ),
              const SizedBox(height: 14),

              // Service Selector Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedService,
                dropdownColor: sheetBg,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Select Service',
                  labelStyle: TextStyle(color: bodyColor),
                  filled: true,
                  fillColor: fieldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Sunday Service - 10:00 AM',
                    child: Text('Sunday Service - 10:00 AM'),
                  ),
                  DropdownMenuItem(
                    value: 'Wednesday Midweek Service - 6:45 PM',
                    child: Text('Wednesday Midweek Service - 6:45 PM'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedService = val);
                },
              ),
              const SizedBox(height: 14),

              // Date Picker Tile
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor),
                ),
                tileColor: fieldBg,
                title: Text(
                  'Planned Visit Date',
                  style: TextStyle(color: bodyColor, fontSize: 12),
                ),
                subtitle: Text(
                  '${_visitDate.year}-${_visitDate.month.toString().padLeft(2, '0')}-${_visitDate.day.toString().padLeft(2, '0')}',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                trailing: const Icon(Icons.calendar_today, color: Color(0xFFCC0000)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _visitDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) setState(() => _visitDate = picked);
                },
              ),
              const SizedBox(height: 16),

              // Children Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bringing Children? (${_children.length})',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  TextButton.icon(
                    onPressed: _addChild,
                    icon: const Icon(Icons.add_circle, color: Color(0xFFCC0000), size: 18),
                    label: const Text('Add Child', style: TextStyle(color: Color(0xFFCC0000))),
                  ),
                ],
              ),
              for (int i = 0; i < _children.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Child ${i + 1} Name',
                            labelStyle: TextStyle(color: bodyColor),
                            filled: true,
                            fillColor: fieldBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onChanged: (v) => _children[i]['firstName'] = v,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                        onPressed: () => setState(() => _children.removeAt(i)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submit(isDark),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Confirm My Visit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required Color fieldBg,
    required Color borderColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
