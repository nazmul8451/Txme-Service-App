import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/JobProgressTime/CountdownTimerWidget.dart';
import '../../../../Widgegt/JobProgressTime/ProviderCountdownTimerWidget.dart';
import '../../../../Widgegt/JobProgressTime/JobTimerController.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../ConfirmPayment/ConfirmPayment.dart';
import 'ProviderToralDurationController.dart';

class Providertotalduration extends StatefulWidget {
  const Providertotalduration({super.key});

  @override
  State<Providertotalduration> createState() => _ProvidertotaldurationState();
}

class _ProvidertotaldurationState extends State<Providertotalduration> {
  final timer = Get.find<JobTimerController>();

  final Providertoraldurationcontroller controller =
  Get.put(Providertoraldurationcontroller());

  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;

  @override
  void initState() {
    super.initState();
    timer.initFromAppointment(appointment);
    // ✅ ADDED: Initialize socket listener for real-time updates
    controller.initSocketListener(appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              AppIcons.chevronleft,
              height: 18.h,
              width: 18.w,
            )),
        title: Padding(
          padding: EdgeInsets.only(left: 70.w),
          child: Text(
            "Total Duration",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.success,
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Job Progress",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1F2937)),
              ),
              SizedBox(
                height: 40.h,
              ),
              JobTimerCard(),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                decoration: BoxDecoration(
                    color: const Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xffFF5A36), width: 1.w)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lawn Mowing & Edging",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff1F2937)),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.location,
                          height: 18.h,
                          width: 16.w,
                          color: const Color(0xff4C545F),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          appointment.residentialAddress?.address ??
                              "No address found",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              color: const Color(0xff1F2937)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.date,
                          height: 18.h,
                          width: 16.w,
                          color: const Color(0xff4C545F),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          appointment.date,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              color: const Color(0xff1F2937)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.prof,
                          height: 18.h,
                          width: 16.w,
                          color: const Color(0xff4C545F),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          appointment.displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              color: const Color(0xff1F2937)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Container(
                width: 353.w,
                height: 137.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  border: Border.all(color: const Color(0xffFF5A36), width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 9.w, right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Notes",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff1F2937)),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Please be careful with the rose bushes near the driveway. The sprinkler system is scheduled to run at 5 PM.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1F2937)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () async {
                  if (controller.isLoading.value) return;

                  final success =
                  await controller.acceptBooking(appointment.id);

                  if (success) {
                    Get.off(
                          () => ConfirmPaymentpage(),
                      arguments: appointment,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to end job",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Container(
                  height: 56.h,
                  width: 353.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xffDA0808),
                  ),
                  child: Center(
                      child: Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "End",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xffFFFFFF)),
                      ))),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
