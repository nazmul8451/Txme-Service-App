import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'RequestBookingController.dart';

class RequestBookingPage extends GetView<RequestBookingController> {
  const RequestBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ---------- HEADER ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// ---------- CALENDAR ----------
                CalendarDatePicker(
                  initialDate: controller.initialDate, // ✅ SAFE
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                  selectableDayPredicate: controller.isDaySelectable,
                  onDateChanged: controller.selectDate,
                ),

                const SizedBox(height: 12),
              ],
            );
          }),
        ),
      ),
    );
  }
}
