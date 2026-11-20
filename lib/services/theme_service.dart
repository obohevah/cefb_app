import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeService manages Light and Dark mode for the app.
/// Defaults to Light Theme as requested.
class ThemeService {
  ThemeService._();

  static const String _prefKey = 'selected_theme_mode';

  /// ValueNotifier holding the current ThemeMode (default: Light).
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Initializes the saved theme mode from SharedPreferences.
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_prefKey);
      if (savedMode == 'dark') {
        themeModeNotifier.value = ThemeMode.dark;
      } else {
        themeModeNotifier.value = ThemeMode.light;
      }
    } catch (_) {
      themeModeNotifier.value = ThemeMode.light;
    }
  }

  /// Toggles between Light and Dark mode instantly.
  static void toggleTheme() {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeModeNotifier.value = newMode;
    unawaited(
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_prefKey, newMode == ThemeMode.light ? 'light' : 'dark');
      }).catchError((_) {}),
    );
  }

  /// Sets a specific theme mode instantly.
  static void setTheme(ThemeMode mode) {
    themeModeNotifier.value = mode;
    unawaited(
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_prefKey, mode == ThemeMode.light ? 'light' : 'dark');
      }).catchError((_) {}),
    );
  }
}
