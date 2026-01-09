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
import 'package:collection/collection.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../Payment/PaymentPage.dart';
import '../../../../Service Provider Role/MyBooking/ConfirmPayment/ConfirmPayment.dart';
import '../../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';

class JobPage extends StatefulWidget {
  JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final Jobprogresspagecontroller jobController =
  Get.put(Jobprogresspagecontroller());

  final timer = Get.find<JobTimerController>();
  final appController = Get.find<AppointmentsController>();

  late String appointmentId;

  @override
  void initState() {
    super.initState();
    final AppointmentModel2 initialAppointment = Get.arguments as AppointmentModel2;
    appointmentId = initialAppointment.id;
    
    // Initial timer setup
    timer.initFromAppointment(initialAppointment);
    
    // Listen for changes in this specific appointment to update timer and handle auto-navigation
    ever(appController.appointments, (List<AppointmentModel2> list) {
      final updated = list.firstWhereOrNull((e) => e.id == appointmentId);
      if (updated != null) {
        timer.initFromAppointment(updated);
        
        final status = updated.status.toLowerCase();
        final role = appController.userRole.value.toUpperCase();
        
        /// 🚀 AUTO NAVIGATION ON STATUS CHANGE
        if (status == "work_completed" || status == "awaiting_payment" || status == "cashpayment") {
            if (role == "CUSTOMER") {
              Get.off(() => Paymentpage(), arguments: updated);
            } else if (role == "PROVIDER") {
              Get.off(() => ConfirmPaymentpage(), arguments: updated);
            }
        } 
        else if (status == "review_pending" || status == "customer_review_pending" || status == "provider_review_pending") {
             Get.off(() => Providerpaymentsuccessful(), arguments: updated);
        }
      }
    });

    // Also listen to sockets directly for faster UI response on this page
    _listenSocket();
  }

  void _listenSocket() {
    final socketApi = SocketApi();
    final eventName = "appointmentUpdate::${appController.userId.value}";
    socketApi.on(eventName, (_) {
       appController.loadData(silent: true);
    });
  }

  @override
  void dispose() {
    // Note: Better to use the controller's onClose but since it's a stateful widget's logic:
    // We don't want to stop the global appController updates, 
    // but maybe we stop our specific 'ever' if we had a reference.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
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
                color: const Color(0xff1F2937)),
          ),
        ),
      ),
      body: Obx(() {
        final appointment = appController.appointments.firstWhereOrNull((e) => e.id == appointmentId) 
                            ?? (Get.arguments as AppointmentModel2);

        return Padding(
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
                      color: const Color(0xff1F2937)),
                ),
                SizedBox(height: 15.h),
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
                                fontSize: 15.sp,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffF7F7F7),
                    border: Border.all(color: const Color(0xffFF5A36), width: 1.w),
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
                            color: const Color(0xff1F2937)),
                      ),
                      Text(
                        AppString.onlyPlease.tr,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1F2937)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),

                if (appController.userRole.value == "PROVIDER")
                  CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.red601,
                    ),
                    child: const Center(
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
                      if (jobController.isLoading.value) return;

                      final success =
                      await jobController.acceptBooking(appointment.id);

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
        );
      }),
    );
  }
}
