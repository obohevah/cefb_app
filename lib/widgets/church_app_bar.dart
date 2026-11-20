import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/models/livestream_status.dart';
import 'package:cefb_app/screens/live_player_screen.dart';
import 'package:cefb_app/services/livestream_service.dart';
import 'package:cefb_app/services/translation_service.dart';
import 'package:cefb_app/services/theme_service.dart';

class ChurchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final VoidCallback? onMenuPressed;

  const ChurchAppBar({
    super.key,
    this.showBackButton = false,
    this.title,
    this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  // Full language list matching the church website and Google Translate
  static const List<Map<String, String>> _allLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'zh-cn', 'name': 'Chinese (Simplified)'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'nl', 'name': 'Dutch'},
    {'code': 'pl', 'name': 'Polish'},
    {'code': 'tr', 'name': 'Turkish'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'id', 'name': 'Indonesian'},
    {'code': 'ms', 'name': 'Malay'},
    {'code': 'sw', 'name': 'Swahili'},
    {'code': 'he', 'name': 'Hebrew'},
    {'code': 'el', 'name': 'Greek'},
    {'code': 'ro', 'name': 'Romanian'},
    {'code': 'hu', 'name': 'Hungarian'},
    {'code': 'cs', 'name': 'Czech'},
    {'code': 'sv', 'name': 'Swedish'},
    {'code': 'da', 'name': 'Danish'},
    {'code': 'fi', 'name': 'Finnish'},
    {'code': 'no', 'name': 'Norwegian'},
    {'code': 'uk', 'name': 'Ukrainian'},
    {'code': 'tl', 'name': 'Filipino'},
  ];

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Language',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _allLanguages.length,
                    itemBuilder: (context, index) {
                      final lang = _allLanguages[index];
                      final code = lang['code']!;
                      final name = lang['name']!;
                      return ValueListenableBuilder<String>(
                        valueListenable: TranslationService.instance.currentLanguage,
                        builder: (context, current, _) {
                          final isSelected = current == code;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF8628E2).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(color: const Color(0xFF8628E2), width: 1.5)
                                  : null,
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                name,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle, color: Color(0xFF8628E2), size: 20)
                                  : null,
                              onTap: () {
                                TranslationService.instance.setLanguage(code);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      toolbarHeight: 72,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            )
          : IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 20),
              ),
              onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!showBackButton) ...[
            Image.asset(
              'assets/images/03.png',
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.church,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'CHRIST EMBASSY',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: showBackButton ? 15 : 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Farmers Branch',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFFFD700),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Live stream badge if online
        ValueListenableBuilder<LiveStreamStatus>(
          valueListenable: LiveStreamService.instance.liveStatus,
          builder: (context, status, _) {
            if (!status.isLive) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LivePlayerScreen(isLive: true)),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE31B23),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Dark / Light Theme Toggle Button
        ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeService.themeModeNotifier,
          builder: (context, mode, _) {
            final isDark = mode == ThemeMode.dark;
            return IconButton(
              tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => ThemeService.toggleTheme(),
            );
          },
        ),

        // Language Picker Button
        ValueListenableBuilder<String>(
          valueListenable: TranslationService.instance.currentLanguage,
          builder: (context, lang, _) {
            return TextButton(
              onPressed: () => _showLanguageDialog(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      lang.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
          ),
        ),
      ),
    );
  }
}
