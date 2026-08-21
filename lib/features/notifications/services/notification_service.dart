import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  dev.log('FCM Background message received: ${message.messageId}');
}

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String _fcmToken =
      'f5U7qLI6TTOv_PmqxNQtZC:APA91bFyazNHKOBqzBdAnDcfT3QZaRVdRDssJydK9fPwKTWucmvE5FyEfuA0nBFut4W2mFqWBuTdkmjSt-OL8CuQXNgokJnoYA4eVtDPk4vjrK3J_GLwDIE';
  bool _isInitialized = false;

  String get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Request permission
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      dev.log('User granted notification permission: ${settings.authorizationStatus}');

      // 2. Setup Local Notifications for Foreground display
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          dev.log('Notification tapped: ${details.payload}');
        },
      );

      // Create Android Notification Channel
      const androidChannel = AndroidNotificationChannel(
        'eduverse_new_lessons_channel',
        'New Lessons & Study Updates',
        description: 'Notifications for newly released video lessons and tests.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // 3. Get FCM Token
      final token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        _fcmToken = token;
        dev.log('Active FCM Device Token: $_fcmToken');
      }

      // Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        notifyListeners();
      });

      // 4. Background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 5. Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        dev.log('FCM Foreground message: ${message.notification?.title}');
        _showForegroundNotification(message);
      });

      // 6. Subscribe to new lessons topic
      await _fcm.subscribeToTopic('new_lessons');

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      dev.log('Error initializing NotificationService: $e');
      _isInitialized = true;
    }
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'New Lesson Available',
      notification.body ?? 'Check out the latest video lessons in EduVerse.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'eduverse_new_lessons_channel',
          'New Lessons & Study Updates',
          channelDescription: 'Notifications for newly released lessons.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['lesson_id'] ?? '',
    );
  }

  /// Trigger a local push notification for a new lesson
  Future<void> showNewLessonNotification({
    required String title,
    required String subject,
    String? duration,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'eduverse_new_lessons_channel',
      'New Lessons & Study Updates',
      channelDescription: 'Notifications for newly released lessons.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🔔 New Lesson Added: $subject',
      '$title ${duration != null ? "($duration)" : ""} is now available for you to watch!',
      details,
      payload: title,
    );
  }
}
