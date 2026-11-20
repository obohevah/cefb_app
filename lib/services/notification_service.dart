import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'livestream_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background message received: ${message.messageId}');
}

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'livestream_channel',
    'Church Live Streams',
    description: 'Notifications for live church services and announcements',
    importance: Importance.high,
    playSound: true,
  );

  final StreamController<String> _onNotificationTapStream =
      StreamController<String>.broadcast();
  Stream<String> get onNotificationTap => _onNotificationTapStream.stream;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Request notification permissions
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('Notification permission status: ${settings.authorizationStatus}');

      // Setup Android channel
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_channel);

      // Setup Local Notifications
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload ?? '';
          _onNotificationTapStream.add(payload);
        },
      );

      // Subscribe to church live stream topic
      await messaging.subscribeToTopic('livestream');
      debugPrint('Subscribed to topic: livestream');

      // Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM Foreground message: ${message.notification?.title}');

        // Refresh live status immediately
        LiveStreamService.instance.checkLive(force: true);

        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null) {
          final videoId = message.data['video_id'] ?? '';
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: android?.smallIcon ?? '@mipmap/ic_launcher',
                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
              ),
            ),
            payload: videoId.toString(),
          );
        }
      });

      // App opened from notification in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final videoId = message.data['video_id'] ?? '';
        LiveStreamService.instance.checkLive(force: true);
        _onNotificationTapStream.add(videoId.toString());
      });

      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }
}
