import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'NotificationCard.dart';
import 'notification_controller.dart';
import 'notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return const Center(
            child: Text(
              'You have no notifications yet.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final groupedNotifications = _groupNotificationsByDate(controller.notificationList);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedNotifications.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(entry.key),
                  ...entry.value.map((notification) => NotificationCard(notification: notification)).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate(List<NotificationModel> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return groupBy(notifications, (NotificationModel n) {
      final notificationDate = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      if (notificationDate == today) {
        return 'Today';
      } else if (notificationDate == yesterday) {
        return 'Yesterday';
      } else {
        return 'Older';
      }
    });
  }

  /// SECTION TITLE WIDGET
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}
