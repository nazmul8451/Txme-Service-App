import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/StaticString/static_string.dart';
import '../../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../../../Widgegt/JobProgressTime/CountdownTimerWidget.dart';
import '../../../../../Widgegt/JobProgressTime/JobTimerController.dart';
import '../../../../Service Provider Role/MyBooking/ProviderTotalDuration/ProviderTotalDuration.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentsController.dart';
import 'JobProgressPageController.dart';

class JobPage extends StatefulWidget {
  JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final Jobprogresspagecontroller controller =
  Get.put(Jobprogresspagecontroller());

  final timer = Get.find<JobTimerController>();

  final String userRole =
      Get.find<AppointmentsController>().userRole.value;

  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;

  @override
  void initState() {
    super.initState();
    timer.initFromAppointment(appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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
            "Job Started",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 45.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              JobTimerCard(),
              SizedBox(height: 28.h),
              Text(
                appointment.description,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1F2937)),
              ),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xffFF5A36), width: 1.w)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lawn Mowing & Edging",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1F2937)),
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
                          color: Color(0xff4C545F),
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
                              color: Color(0xff1F2937)),
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
                          color: Color(0xff4C545F),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          appointment.date,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              color: Color(0xff1F2937)),
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
                          color: Color(0xff4C545F),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          appointment.displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18.sp,
                              color: Color(0xff1F2937)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  border: Border.all(color: Color(0xffFF5A36), width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Job Notes",
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1F2937)),
                    ),
                    Text(
                      AppString.onlyPlease.tr,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1F2937)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),

              if (userRole == "PROVIDER")
                CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.red601,
                  ),
                  child: Center(
                    child: Text(
                      "Start",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                  onTap: () async {
                    ///  prevent double tap
                    if (controller.isLoading.value) return;

                    final success =
                    await controller.acceptBooking(appointment.id);

                    ///  API SUCCESS → GO TO JOB PAGE
                    if (success) {
                      Get.off(
                            () => Providertotalduration(),
                        arguments: appointment, //  FULL MODEL
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to accept booking",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              SizedBox(
                height: 50.h,
              ),


            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
