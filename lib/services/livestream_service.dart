import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/livestream_status.dart';
import 'api_service.dart';

/// Manages live stream detection, background polling, and status notifications
class LiveStreamService {
  static final LiveStreamService instance = LiveStreamService._();
  LiveStreamService._();

  final ValueNotifier<LiveStreamStatus> liveStatus =
      ValueNotifier<LiveStreamStatus>(LiveStreamStatus.offline());

  final ValueNotifier<bool> isChecking = ValueNotifier<bool>(false);

  Timer? _pollingTimer;
  bool _initialized = false;

  void initialize() {
    if (_initialized) return;
    _initialized = true;

    // Check immediately on startup
    checkLive(force: true);

    // Periodic check every 30 seconds for prompt live stream detection
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkLive();
    });
  }

  /// Manually trigger a fresh check (e.g. from pull-to-refresh)
  Future<LiveStreamStatus> checkLive({bool force = false}) async {
    isChecking.value = true;
    try {
      final status = await ApiService.checkLiveStatus(force: force);
      liveStatus.value = status;
      return status;
    } finally {
      isChecking.value = false;
    }
  }

  void dispose() {
    _pollingTimer?.cancel();
  }
}
