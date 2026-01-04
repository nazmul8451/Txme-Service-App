import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import 'NotificationCard.dart';
import 'notification_controller.dart';

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
        if (controller.isLoading.isTrue &&
            controller.notificationList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            child: Stack(
              children: <Widget>[
                ListView(), // For RefreshIndicator to work on empty screen
                const Center(
                  child: Text(
                    'You have no notifications yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: Stack(
                  children: [
                    ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemCount: controller.notificationList.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notificationList[index];
                        return NotificationCard(notification: notification);
                      },
                    ),
                    if (controller.isLoading.isTrue)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            _buildPaginationControls(controller),
          ],
        );
      }),
    );
  }

  Widget _buildPaginationControls(NotificationController controller) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white,
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                if (controller.currentPage.value > 1)
                  ElevatedButton(
                    onPressed: controller.isLoading.isTrue
                        ? null
                        : controller.loadPreviousPage,
                    child: const Text('Previous'),
                  )
                else
                  const SizedBox(width: 80), // Keep space for alignment

                // Page Indicator
                Text(
                  'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // Next Button
                if (controller.currentPage.value < controller.totalPages.value)
                  ElevatedButton(
                    onPressed: controller.isLoading.isTrue
                        ? null
                        : controller.loadNextPage,
                    child: const Text('Next'),
                  )
                else
                  const SizedBox(width: 80), // Keep space for alignment
              ],
            )),
      ),
    );
  }
}
