import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/CustomBottomNavBar/ProviderNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'CancelBookingController.dart';

class Cancelbooking extends StatelessWidget {
  Cancelbooking({super.key});

  final CancelBookingController controller =
  Get.put(CancelBookingController());

  @override
  Widget build(BuildContext context) {
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

              SizedBox(height: 20.h),

              Text(
                "This will cancel Handyman service with Sarah",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff4C545F),
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

                  /// Radio Buttons (Gap reduced)
                  Obx(() => Column(
                    children: controller.reasons.map((reason) {
                      return RadioListTile<String>(
                        value: reason,
                        groupValue: controller.selectedReason.value,
                        onChanged: (value) =>
                            controller.selectReason(value!),
                        activeColor: Colors.blue,
                        dense: true,
                        visualDensity:
                        const VisualDensity(vertical: -2),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
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
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: controller.selectedReason.value ==
                              "Other"
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: Colors.blue),
                      ),
                    ),
                  )),
                ],
              ),

              SizedBox(height: 40.h),

              /// Confirm Button
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xffDA0808),
                ),
                child: const Center(
                  child: Text(
                    "Confirm Cancellation",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
                onTap: () {
                  controller.confirmCancellation();
                  Get.toNamed(AppRoute.providerHomeScreen);
                },
              ),
            ],
          ),
        ),
      ),

      //bottomNavigationBar: const CustomProvidernavbar(selectedIndex: 1),


      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
