import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Picture-in-Picture (PiP) Service
/// Enables smooth, crash-free Android native Picture-in-Picture mode
class PipService {
  static const MethodChannel _channel = MethodChannel('com.church.app/pip');

  /// Tracks whether the app is currently displaying in PiP mode
  static final ValueNotifier<bool> isInPipMode = ValueNotifier<bool>(false);

  static bool _initialized = false;
  static bool? _supported;

  static void initialize() {
    if (_initialized) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPipModeChanged') {
        final inPip = call.arguments == true;
        isInPipMode.value = inPip;
        debugPrint('PipService: onPipModeChanged -> $inPip');
      }
    });
    _initialized = true;
  }

  /// Check whether the device supports native Android PiP
  static Future<bool> isPipSupported() async {
    if (_supported != null) return _supported!;
    try {
      final res = await _channel.invokeMethod<bool>('isPipSupported');
      _supported = res ?? false;
      return _supported!;
    } catch (e) {
      debugPrint('Pip check error: $e');
      _supported = false;
      return false;
    }
  }

  /// Request the OS to enter Picture-in-Picture mode with 16:9 aspect ratio
  static Future<bool> enterPipMode({int width = 16, int height = 9}) async {
    try {
      final res = await _channel.invokeMethod<bool>('enterPipMode', {
        'width': width,
        'height': height,
      });
      return res ?? false;
    } catch (e) {
      debugPrint('Failed to enter PiP: $e');
      return false;
    }
  }

  /// Enable or disable auto-entering PiP when pressing Home / swiping up (Android 12+)
  static Future<void> setAutoPipEnabled(bool enable) async {
    try {
      await _channel.invokeMethod('enableAutoPip', {'enable': enable});
    } catch (e) {
      debugPrint('setAutoPipEnabled error: $e');
    }
  }
}
