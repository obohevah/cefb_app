import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/livestream_status.dart';
import '../services/livestream_service.dart';

class ChurchBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ChurchBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F1E) : Colors.white;
    final activeColor = const Color(0xFFE31B23);
    final inactiveColor = isDark ? Colors.white60 : Colors.black54;

    return ValueListenableBuilder<LiveStreamStatus>(
      valueListenable: LiveStreamService.instance.liveStatus,
      builder: (context, status, _) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 58,
              child: Row(
                children: [
                  _navItem(
                    index: 0,
                    label: 'Home',
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    isSelected: currentIndex == 0,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                  _navItem(
                    index: 1,
                    label: status.isLive ? 'LIVE' : 'Watch',
                    icon: Icons.play_circle_outline,
                    activeIcon: Icons.play_circle,
                    isSelected: currentIndex == 1,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    badge: status.isLive,
                  ),
                  _navItem(
                    index: 2,
                    label: 'Gallery',
                    icon: Icons.photo_library_outlined,
                    activeIcon: Icons.photo_library,
                    isSelected: currentIndex == 2,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                  _navItem(
                    index: 3,
                    label: 'Giving',
                    icon: Icons.volunteer_activism_outlined,
                    activeIcon: Icons.volunteer_activism,
                    isSelected: currentIndex == 3,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                  _navItem(
                    index: 4,
                    label: 'More',
                    icon: Icons.menu,
                    activeIcon: Icons.menu,
                    isSelected: currentIndex == 4,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required Color activeColor,
    required Color inactiveColor,
    bool badge = false,
  }) {
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: 22,
                ),
                if (badge)
                  Positioned(
                    top: -1,
                    right: -3,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE31B23),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
