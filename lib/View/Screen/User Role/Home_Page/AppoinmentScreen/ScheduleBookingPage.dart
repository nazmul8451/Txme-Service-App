import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BookingScheduleController.dart';

class BookingSchedulePage extends GetView<BookingScheduleController> {
  const BookingSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),

      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- GREETING --------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Good Morning, Sady",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// -------- DATE SCROLLER --------
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.dates.length,
                itemBuilder: (_, index) {
                  final item = controller.dates[index];
                  final isSelected =
                      controller.selectedIndex.value == index;

                  return GestureDetector(
                    onTap: () => controller.onDateTap(index),
                    child: Container(
                      width: 55,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFF5A36)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item["day"].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["week"],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            /// -------- SCHEDULE AREA --------
            Expanded(
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: SizedBox(
                  height: 520,
                  child: Stack(
                    children: [

                      /// TIME COLUMN
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: List.generate(5, (i) {
                            final hour = 8 + (i * 2);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 28),
                              child: Text(
                                "${hour.toString().padLeft(2, '0')}.00",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      /// SLOTS
                      ...controller.slots.asMap().entries.map((e) {
                        final index = e.key;
                        final slot = e.value;

                        final isSelected =
                            controller.selectedSlotIndex.value ==
                                index;

                        Color bgColor;
                        String label;

                        if (!slot.available) {
                          bgColor = const Color(0xFF1F2937);
                          label = "Not Available";
                        } else if (isSelected) {
                          bgColor = Colors.grey.shade400;
                          label = "Booking";
                        } else {
                          bgColor = const Color(0xFFFF5A36);
                          label = "Available";
                        }

                        return Positioned(
                          top: controller
                              .getTopPosition(slot.startTime),
                          left: 80,
                          child: GestureDetector(
                            onTap: slot.available
                                ? () =>
                                controller.onSlotTap(index)
                                : null,
                            child: Container(
                              width: 130,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${slot.startTime} - ${slot.endTime}",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            /// -------- CONFIRM BUTTON --------
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFFF5A36),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: controller.selectedSlotIndex.value == -1
                      ? null
                      : () {
                    ///  booking API later
                  },
                  child: const Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,)
          ],
        );
      }),
    );
  }
}
