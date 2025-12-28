import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'CancelBookingController.dart';

class Cancelbooking extends StatelessWidget {
  Cancelbooking({super.key});

  final CancelBookingController controller =
  Get.put(CancelBookingController());

  @override
  Widget build(BuildContext context) {

    final String appointmentId = Get.arguments as String;

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AppIcons.chevronleft),
        ),
        title: Text(
          "Cancel Booking",
          style: TextStyle(
            color: const Color(0xff333333),
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              SvgPicture.asset(AppIcons.group, height: 80.h, width: 80.w),

              SizedBox(height: 20.h),

              Text(
                "Are you sure you want",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1F2937),
                ),
              ),
              Text(
                "to cancel?",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1F2937),
                ),
              ),

              SizedBox(height: 40.h),

              /// Reason Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason for decline request",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff1F2937),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// Radio Buttons
                  Obx(() => Column(
                    children: controller.reasons.map((reason) {
                      return RadioListTile<String>(
                        value: reason,
                        groupValue: controller.selectedReason.value,
                        onChanged: (value) =>
                            controller.selectReason(value!),
                        activeColor: Colors.blue,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff4C545F),
                          ),
                        ),
                      );
                    }).toList(),
                  )),

                  SizedBox(height: 8.h),

                  /// Note Field
                  Obx(() => TextField(
                    controller: controller.noteController,
                    enabled:
                    controller.selectedReason.value == "Other",
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Please specify",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )),
                ],
              ),

              SizedBox(height: 40.h),

              Obx(() =>  controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)

                  : CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xffDA0808),
                ),
                child: Center(
                  child: Text(
                    "Confirm Cancellation",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () async {
                  if (controller.selectedReason.isEmpty) {
                    Get.snackbar("Error", "Please select a reason");
                    return;
                  }

                  if (controller.selectedReason.value == "Other" &&
                      controller.noteController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please write a reason");
                    return;
                  }

                  final success =
                  await controller.cancelBooking(appointmentId);

                  if (success) {
                    Get.offAllNamed(AppRoute.appointmentsPage);
                  } else {
                    Get.snackbar("Error", "Action failed");
                  }
                },

              )),

            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
