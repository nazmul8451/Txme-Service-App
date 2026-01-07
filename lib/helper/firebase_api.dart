import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';
import '../View/Screen/User Role/Home_Page/NotificationPage/notification_controller.dart'; // ✅ ADDED

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  // ✅ ADDED: Refresh notification list on background message
  if (Get.isRegistered<NotificationController>()) {
    await Get.find<NotificationController>().refreshNotifications();
  }

  final notification = message.notification;
  if (notification == null) return;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  await _localNotifications.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));

  _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
      ),
    ),
    payload: jsonEncode(message.data),
  );
  debugPrint("Handling a background message: ${message.messageId}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    if (fcmToken != null) {
      await _saveFcmToken(fcmToken);
    }

    _firebaseMessaging.onTokenRefresh.listen(_saveFcmToken);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    _handleIncomingMessages();
  }

  Future<void> _saveFcmToken(String token) async {
    try {
      final bearerToken = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (bearerToken.isEmpty) return;

      await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.userFcmToken}"),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );
    } catch (e) {
      debugPrint("❌ Failed to save FCM token: $e");
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(settings, 
      onDidReceiveNotificationResponse: (response) {
        // TODO: Handle notification tap and navigate to the correct screen
      },
    );
  }

  void _handleIncomingMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       // ✅ ADDED: Refresh notification list on foreground message
      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().refreshNotifications();
      }

      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // TODO: Handle app opening from a terminated state via notification
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO: Handle app opening from the background via notification
    });
  }
}
