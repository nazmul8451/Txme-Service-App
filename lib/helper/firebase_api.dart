import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';
import '../View/Screen/User Role/Home_Page/NotificationPage/NotificationHandler.dart';
import '../View/Screen/User Role/Home_Page/NotificationPage/notification_controller.dart';

//  Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Refresh notifications if controller is registered
  if (Get.isRegistered<NotificationController>()) {
    await Get.find<NotificationController>().refreshNotifications();
  }

  final notification = message.notification;
  if (notification == null) return;

  // Show local notification
  final localNotifications = FlutterLocalNotificationsPlugin();
  await localNotifications.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));

  await localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: jsonEncode(message.data),
  );

  debugPrint("📱 Background message: ${message.messageId}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  // ✅ Main initialization method
  Future<void> initNotifications() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted notification permission');

      // Get FCM token
      final fcmToken = await _firebaseMessaging.getToken();
      debugPrint('🔥 FCM Token: $fcmToken');

      if (fcmToken != null) {
        await _saveFcmToken(fcmToken);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_saveFcmToken);

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Initialize local notifications
      await _initLocalNotifications();

      // Handle incoming messages
      _handleIncomingMessages();
    } else {
      debugPrint('❌ User declined notification permission');
    }
  }

  // ✅ Save FCM token to backend
  Future<void> _saveFcmToken(String token) async {
    final bearerToken = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (bearerToken.isEmpty) {
      debugPrint("⚠️ Auth token not found, skipping FCM token save.");
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.userFcmToken}"),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ FCM Token saved to backend successfully");
      } else {
        debugPrint("❌ Failed to save FCM token. Status: ${response.statusCode}");
        debugPrint("   Response: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Exception while saving FCM token: $e");
    }
  }

  // ✅ Initialize local notifications
  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(); // ✅ Added iOS settings
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          _handleNotificationTap(payload);
        }
      },
    );

    //  Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // ✅ Handle notification tap
  void _handleNotificationTap(String payload) {
    try {
      final data = jsonDecode(payload);
      debugPrint("📱 Notification tapped with data: $data");

      // ✅ NotificationHandler দিয়ে handle করো
      NotificationHandler.handleNotification(data);
    } catch (e) {
      debugPrint("❌ Error handling notification tap: $e");
    }
  }

  // ✅ Handle incoming messages
  void _handleIncomingMessages() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message received: ${message.messageId}");

      // Refresh notifications list
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().refreshNotifications();
      }

      final notification = message.notification;
      if (notification == null) return;

      // Show local notification
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });

    // App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("📱 App opened from terminated state");
        final data = message.data;
        if (data.isNotEmpty) {
          _handleNotificationTap(jsonEncode(data));
        }
      }
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📱 App opened from background");
      final data = message.data;
      if (data.isNotEmpty) {
        _handleNotificationTap(jsonEncode(data));
      }
    });
  }
}