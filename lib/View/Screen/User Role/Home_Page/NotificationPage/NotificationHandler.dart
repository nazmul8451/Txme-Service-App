import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationHandler {

  // ✅ Handle notification tap - automatically navigate based on 'screen' field
  static void handleNotification(Map<String, dynamic> data) {
    debugPrint('📱 Notification data: $data');

    // Get the screen/route from notification data
    final screen = data['screen']?.toString() ?? '';
    final type = data['type']?.toString() ?? '';
    final title = data['title']?.toString() ?? 'Notification';
    final message = data['message']?.toString() ?? '';

    // Show snackbar
    _showSnackbar(title, message);

    // Navigate based on screen field (যেমন তোমার NotificationModel এ আছে)
    if (screen.isNotEmpty) {
      _navigateToScreen(screen, data);
    } else if (type.isNotEmpty) {
      // Fallback: যদি screen না থাকে, type দেখে navigate করো
      _navigateBasedOnType(type, data);
    } else {
      // Default: notification page এ যাও
      _navigateToNotificationPage();
    }
  }

  // ✅ Show snackbar
  static void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      snackPosition: SnackPosition.TOP,
      isDismissible: true,
    );
  }

  // ✅ Navigate to specific screen (based on 'screen' field)
  static void _navigateToScreen(String screen, Map<String, dynamic> data) {
    try {
      // Ensure screen starts with '/'
      if (!screen.startsWith('/')) {
        screen = '/$screen';
      }

      debugPrint('📱 Navigating to: $screen');
      Get.toNamed(screen, arguments: data);
    } catch (e) {
      debugPrint('❌ Error navigating to $screen: $e');
      _navigateToNotificationPage();
    }
  }

  //  Navigate based on type (optional fallback)
  static void _navigateBasedOnType(String type, Map<String, dynamic> data) {
    debugPrint('📱 Notification type: $type');

    // তুমি চাইলে এখানে specific type handling add করতে পারো
    // Example:

    switch (type) {
      case 'topup':
        Get.toNamed('/wallet', arguments: data);
        break;
      case 'order':
        Get.toNamed('/orders', arguments: data);
        break;
      default:
        _navigateToNotificationPage();
    }


    // এখনকার জন্য notification page এ যাও
    _navigateToNotificationPage();
  }

  // ✅ Navigate to notification page (default)
  static void _navigateToNotificationPage() {
    debugPrint('📱 Navigating to notification page');

    // তোমার notification page এর route
    // তোমার AppRoute থেকে notification route টা use করো
    Get.toNamed('/notification'); // ✅ তোমার actual route এখানে দাও
  }
}