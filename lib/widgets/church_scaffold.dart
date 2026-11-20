import 'package:flutter/material.dart';
import '../screens/gallery_screen.dart';
import '../screens/give_screen.dart';
import '../screens/home_screen.dart';
import '../screens/video_archive_screen.dart';
import 'church_app_bar.dart';
import 'church_bottom_nav.dart';
import 'church_drawer.dart';
import 'plan_visit_sheet.dart';

class ChurchScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String? title;
  final bool showBackButton;
  final bool showBottomNav;
  final bool showFab;

  ChurchScaffold({
    super.key,
    required this.body,
    this.currentIndex = -1,
    this.title,
    this.showBackButton = false,
    this.showBottomNav = true,
    this.showFab = true,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onBottomNavTap(BuildContext context, int index) {
    if (index == 4) {
      // 'More' button: open navigation drawer immediately
      _scaffoldKey.currentState?.openDrawer();
      return;
    }

    if (index == 0) {
      // Pop all subpages back to HomeScreen root
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (currentIndex != 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
      return;
    }

    if (index == currentIndex) return;

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoArchiveScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryScreen()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GiveScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChurchAppBar(
        showBackButton: showBackButton,
        title: title,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const ChurchDrawer(),
      body: body,
      bottomNavigationBar: showBottomNav
          ? ChurchBottomNav(
              currentIndex: currentIndex,
              onTap: (i) => _onBottomNavTap(context, i),
            )
          : null,
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: () => PlanVisitSheet.show(context),
              backgroundColor: const Color(0xFFE31B23),
              icon: const Icon(Icons.calendar_month, color: Colors.white, size: 18),
              label: const Text(
                'Plan Visit',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            )
          : null,
    );
  }
}
