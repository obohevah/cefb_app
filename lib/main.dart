import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/live_player_screen.dart';
import 'services/livestream_service.dart';
import 'services/notification_service.dart';
import 'services/pip_service.dart';
import 'services/translation_service.dart';
import 'services/theme_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Fast local preference initialization
  await ThemeService.initialize();

  // 2. Render Flutter UI immediately on frame 1 to eliminate any white flash / delay
  runApp(const ChristEmbassyApp());

  // 3. Launch background services concurrently while SplashScreen is animating
  _initBackgroundServices();
}

void _initBackgroundServices() {
  // Device orientations and System UI styling
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0F1E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Core background services
  PipService.initialize();
  TranslationService.instance.initialize();
  LiveStreamService.instance.initialize();

  // Firebase Push Notifications (runs in background without blocking startup)
  NotificationService.instance.initialize().then((_) {
    NotificationService.instance.onNotificationTap.listen((videoId) {
      if (videoId.isNotEmpty) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => LivePlayerScreen(
              videoId: videoId,
              title: 'Christ Embassy Farmers Branch - Live Service',
              isLive: true,
            ),
          ),
        );
      }
    });
  }).catchError((e) {
    debugPrint('Firebase Notification init caught: $e');
  });
}

class ChristEmbassyApp extends StatelessWidget {
  const ChristEmbassyApp({super.key});

  static final _lightTextTheme = GoogleFonts.montserratTextTheme(ThemeData.light().textTheme);
  static final _darkTextTheme = GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme);

  static final _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F7FA),
    cardColor: Colors.white,
    primaryColor: const Color(0xFFE31B23),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE31B23),
      secondary: Color(0xFF8628E2),
      surface: Colors.white,
    ),
    textTheme: _lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8628E2),
      elevation: 0,
    ),
  );

  static final _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F1E),
    cardColor: const Color(0xFF1A1A2E),
    primaryColor: const Color(0xFFE31B23),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE31B23),
      secondary: Color(0xFF8628E2),
      surface: Color(0xFF14142B),
    ),
    textTheme: _darkTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8628E2),
      elevation: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeModeNotifier,
      child: const SplashScreen(),
      builder: (context, themeMode, homeChild) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'CEFB',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeAnimationDuration: const Duration(milliseconds: 200),
          themeAnimationCurve: Curves.easeInOut,
          home: homeChild,
        );
      },
    );
  }
}
