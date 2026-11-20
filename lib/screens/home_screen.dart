import 'package:flutter/material.dart';
import 'package:cefb_app/services/livestream_service.dart';
import 'package:cefb_app/widgets/church_scaffold.dart';
import 'package:cefb_app/widgets/live_stream_card.dart';
import 'package:cefb_app/widgets/video_welcome_popup.dart';
import 'package:cefb_app/widgets/image_popup_carousel.dart';

// Modular Home Sections
import 'package:cefb_app/widgets/home_sections/hero_section.dart';
import 'package:cefb_app/widgets/home_sections/sub_banner_section.dart';
import 'package:cefb_app/widgets/home_sections/church_info_section.dart';
import 'package:cefb_app/widgets/home_sections/church_online_card_section.dart';
import 'package:cefb_app/widgets/home_sections/watch_again_section.dart';
import 'package:cefb_app/widgets/home_sections/ministry_cards_section.dart';
import 'package:cefb_app/widgets/home_sections/plan_visit_section.dart';
import 'package:cefb_app/widgets/home_sections/welcome_section.dart';
import 'package:cefb_app/widgets/home_sections/pastor_section.dart';
import 'package:cefb_app/widgets/home_sections/gallery_preview_section.dart';
import 'package:cefb_app/widgets/home_sections/kids_teens_section.dart';
import 'package:cefb_app/widgets/home_sections/locations_times_section.dart';
import 'package:cefb_app/widgets/home_sections/test_drive_sermon_section.dart';
import 'package:cefb_app/widgets/home_sections/closing_welcome_section.dart';
import 'package:cefb_app/widgets/home_sections/faq_section.dart';
import 'package:cefb_app/widgets/home_sections/closing_cta_section.dart';
import 'package:cefb_app/widgets/home_sections/church_footer_section.dart';

/// Clean, modular Home Screen presenting all church website features.
/// Uses simple StatelessWidget sections for readability and maintainability.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<HeroSectionState> _heroKey = GlobalKey<HeroSectionState>();

  @override
  void initState() {
    super.initState();

    // Trigger website welcome popups on app launch
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;

      // 1. Pause hero background video and show Video Welcome Popup
      _heroKey.currentState?.pauseVideo();
      await VideoWelcomePopup.show(context);
      if (!mounted) return;
      _heroKey.currentState?.resumeVideo();

      // 2. Fetch and show Event Announcement Flyers Carousel immediately after video popup closes
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      await ImagePopupCarousel.fetchAndShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChurchScaffold(
      currentIndex: 0,
      body: RefreshIndicator(
        color: const Color(0xFFE31B23),
        backgroundColor: Theme.of(context).cardColor,
        onRefresh: () async {
          await LiveStreamService.instance.checkLive(force: true);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Live Stream Banner (displays when service is streaming)
            const LiveStreamCard(),

            // 1. Hero Video Section with Mute toggle & CTA buttons
            HeroSection(key: _heroKey),

            // 2. Sub-Banner: "Looking for a loving church in Carrollton, TX?"
            const SubBannerSection(),

            // 3. Church Info & Service Times Gradient Card
            const ChurchInfoSection(),

            // 3b. Church Online Platform (Countdown & Interactive Chat)
            const ChurchOnlineCardSection(),

            // 4. Watch Again / Replay Inspiring Video Section
            WatchAgainSection(
              onVideoStarted: () => _heroKey.currentState?.pauseVideo(),
              onVideoStopped: () => _heroKey.currentState?.resumeVideo(),
            ),

            // 5. Ministry Feature Cards (New Here, Loveworld Kids, Cell Groups)
            const MinistryCardsSection(),

            // 6. Plan Your Visit Section (6 VIP visitor guarantees)
            const PlanVisitSection(),

            // 7. Welcome Section: "We don't judge. We value people."
            const WelcomeSection(),

            // 8. Pastor MJ Akintobi (Oboh) Welcome Section
            const PastorSection(),

            // 9. Interactive Gallery Preview ("Captured Moments & Blessed Memories")
            const GalleryPreviewSection(),

            // 10. Kids & Teens Church Overview
            const KidsTeensSection(),

            // 11. Locations & Times (Physical Campus & Online Church)
            const LocationsTimesSection(),

            // 12. Test Drive a Sermon (YouTube video carousel)
            const TestDriveSermonSection(),

            // 13. Closing Welcome & Heartfelt Invitation
            const ClosingWelcomeSection(),

            // 14. Frequently Asked Questions (FAQ) Accordion
            const FAQSection(),

            // 15. Closing Call to Action Banner
            const ClosingCTASection(),

            // 16. Full Website-Matching Church Footer
            const ChurchFooterSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
