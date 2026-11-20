import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/livestream_status.dart';
import '../screens/about_screen.dart';
import '../screens/believe_god_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/events_screen.dart';
import '../screens/first_steps_screen.dart';
import '../screens/foundation_school_screen.dart';
import '../screens/gallery_screen.dart';
import '../screens/give_screen.dart';
import '../screens/groups_screen.dart';
import '../screens/kids_screen.dart';
import '../screens/live_player_screen.dart';
import '../screens/need_prayer_screen.dart';
import '../screens/new_here_screen.dart';
import '../screens/our_beliefs_screen.dart';
import '../screens/our_president_screen.dart';
import '../screens/salvation_screen.dart';
import '../screens/video_archive_screen.dart';
import '../screens/church_online_screen.dart';
import '../services/livestream_service.dart';
import '../services/theme_service.dart';
import 'translated_text.dart';

class ChurchDrawer extends StatelessWidget {
  const ChurchDrawer({super.key});

  void _nav(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkTheme ? const Color(0xFF0F0F1E) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/03.png',
                      height: 52,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.church,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHRIST EMBASSY',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Farmers Branch',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFFD700),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Giving your life a meaning',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Theme Switcher Tile
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService.themeModeNotifier,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: const Color(0xFF8628E2),
                ),
                title: Text(
                  isDark ? 'Dark Theme' : 'Light Theme',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: isDark,
                activeThumbColor: const Color(0xFF8628E2),
                onChanged: (val) => ThemeService.toggleTheme(),
              );
            },
          ),

          const Divider(height: 16),

          // 1. Live Stream
          ValueListenableBuilder<LiveStreamStatus>(
            valueListenable: LiveStreamService.instance.liveStatus,
            builder: (context, status, _) {
              return _drawerItem(
                context,
                icon: Icons.live_tv,
                title: 'Live Service',
                iconColor: status.isLive ? const Color(0xFFE31B23) : null,
                trailing: status.isLive
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE31B23),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'LIVE',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  if (status.isLive && status.videoId != null) {
                    _nav(context, LivePlayerScreen(videoId: status.videoId!, title: status.title, isLive: true));
                  } else {
                    _nav(context, const VideoArchiveScreen());
                  }
                },
              );
            },
          ),

          // 2. Previous Videos
          _drawerItem(
            context,
            icon: Icons.video_library_outlined,
            title: 'Previous Videos',
            onTap: () => _nav(context, const VideoArchiveScreen()),
          ),

          // 3. Church Online Platform (Live Interactive Chat & Countdown)
          _drawerItem(
            context,
            icon: Icons.cell_tower,
            title: 'Church Online Platform',
            subtitle: 'Countdown • Live Chat • Bible',
            iconColor: const Color(0xFF8628E2),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF8628E2).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF8628E2).withOpacity(0.3)),
              ),
              child: const Text(
                'LIVE CHAT',
                style: TextStyle(
                  color: Color(0xFF8628E2),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            onTap: () => _nav(context, const ChurchOnlineScreen()),
          ),

          const Divider(height: 20),

          // Section Header: About & Beliefs
          _sectionHeader('OUR CHURCH'),

          _drawerItem(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () => _nav(context, const AboutScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.person_outline,
            title: 'Our President',
            onTap: () => _nav(context, const OurPresidentScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.menu_book_outlined,
            title: 'Our Beliefs',
            onTap: () => _nav(context, const OurBeliefsScreen()),
          ),

          const Divider(height: 20),

          // Section Header: Connect & Community
          _sectionHeader('COMMUNITY'),

          _drawerItem(
            context,
            icon: Icons.door_front_door_outlined,
            title: 'New Here',
            onTap: () => _nav(context, const NewHereScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.directions_walk,
            title: 'First Steps',
            onTap: () => _nav(context, const FirstStepsScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.groups_outlined,
            title: 'Connect Groups',
            onTap: () => _nav(context, const GroupsScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.child_care_outlined,
            title: 'Kids Ministry',
            onTap: () => _nav(context, const KidsScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.event_outlined,
            title: 'Events',
            onTap: () => _nav(context, const EventsScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.photo_library_outlined,
            title: 'Photo Gallery',
            onTap: () => _nav(context, const GalleryScreen()),
          ),

          const Divider(height: 20),

          // Section Header: Grow & Give
          _sectionHeader('GROWTH & GIVING'),

          _drawerItem(
            context,
            icon: Icons.favorite_outline,
            title: 'Salvation',
            onTap: () => _nav(context, const SalvationScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.school_outlined,
            title: 'Foundation School',
            onTap: () => _nav(context, const FoundationSchoolScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.volunteer_activism_outlined,
            title: 'Giving',
            onTap: () => _nav(context, const GiveScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.shield_outlined,
            title: 'I Believe God',
            onTap: () => _nav(context, const BelieveGodScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.handshake_outlined,
            title: 'Need Prayer?',
            onTap: () => _nav(context, const NeedPrayerScreen()),
          ),
          _drawerItem(
            context,
            icon: Icons.contact_mail_outlined,
            title: 'Contact Us',
            onTap: () => _nav(context, const ContactScreen()),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 6, top: 4),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: const Color(0xFF8628E2),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: iconColor ?? const Color(0xFF8628E2), size: 22),
      title: TranslatedText(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
