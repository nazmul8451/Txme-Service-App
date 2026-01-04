import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentsController.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../PaymentSuccessful/ProviderPaymentSuccessful.dart';
import 'ConfirmPaymentController.dart';

class ConfirmPaymentpage extends StatefulWidget {
  const ConfirmPaymentpage({super.key});

  @override
  State<ConfirmPaymentpage> createState() => _ConfirmPaymentpageState();
}

class _ConfirmPaymentpageState extends State<ConfirmPaymentpage> {
  final Confirmpaymentcontroller controller = Get.put(Confirmpaymentcontroller());
  final appController = Get.find<AppointmentsController>();
  late String appointmentId;

  @override
  void initState() {
    super.initState();
    final AppointmentModel2 initialAppointment = Get.arguments as AppointmentModel2;
    appointmentId = initialAppointment.id;

    ever(appController.appointments, (List<AppointmentModel2> list) {
      final updated = list.firstWhereOrNull((e) => e.id == appointmentId);
      if (updated != null) {
        final status = updated.status.toLowerCase();
        if (status == "review_pending" || status == "customer_review_pending" || status == "provider_review_pending") {
           Get.off(() => Providerpaymentsuccessful(), arguments: updated);
        }
      }
    });

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
          child: const Text(
            "Confirm Payment",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Obx(() {
        final appointment = appController.appointments.firstWhereOrNull((e) => e.id == appointmentId) 
                            ?? (Get.arguments as AppointmentModel2);

        return Padding(
          padding: EdgeInsets.only(top: 12.h, left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Did you receive the ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 32.sp,
                      color: const Color(0xff1F2937)),
                ),
                Text(
                  "payment from the ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 32.sp,
                      color: const Color(0xff1F2937)),
                ),
                Text(
                  "client?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 32.sp,
                      color: const Color(0xff1F2937)),
                ),

                Center(
                  child: Text(
                    "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFF5A36),
                    ),
                  ),
                ),

                SizedBox(height: 8.h,),


                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xffFF5A36), width: 1.w)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Job Details",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1F2937)),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "Service:",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff1F2937)),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "Date:",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff1F2937)),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "Name:",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff1F2937)),
                          ),
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: 30.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 12.h),
                            Text(
                              appointment.description,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff4C545F)),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              appointment.date,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff4C545F)),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              appointment.displayName,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff4C545F)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 351.w,
                  height: 173.h,
                  decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xffFF5A36), width: 1.w)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, right: 160.w),
                        child: Text(
                          "Invoice Breakdown",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff1F2937)),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time Worked:",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w200,
                                  color: const Color(0xff4C545F)),
                            ),
                            Text(
                              "${appointment.totalWorkedTime?.toStringAsFixed(1) ?? '0'} hrs",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1F2937),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hourly Rate:",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w200,
                                  color: const Color(0xff4C545F)),
                            ),
                            Text(
                              "€ ${appointment.hourlyRate?.toStringAsFixed(2) ?? '0.00'}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1F2937),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Container(
                        width: 331.w,
                        height: 1.h,
                        color: const Color(0xff4C545F),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff1F2937)),
                            ),
                            Text(
                              "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff3A7DFF)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),

                CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xffFF5A36),
                    ),
                    child: Center(
                        child: Text(
                      "Yes, I received",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffFFFFFF)),
                    )),

                    onTap: () async {
                      if (controller.isLoading.value) return;

                      final currentStatus = appointment.status.toLowerCase();
                      bool success = false;

                      if (currentStatus == "work_completed" || currentStatus == "awaiting_payment" || currentStatus == "cashpayment") {
                        success = await controller.acceptBooking(appointment.id);
                      } else if (currentStatus.contains("review")) {
                        success = true; 
                      }

                      if (success) {
                        Get.off(() => Providerpaymentsuccessful(), arguments: appointment);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Could not confirm payment. The appointment may have already been processed.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    ),

                SizedBox(
                  height: 28.h,
                ),

                GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoute.contactsupport);
                  },
                  child: Text("Need help? Contact support", style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff3A7DFF)
                  ),),
                ),

                SizedBox(
                  height: 118.h,
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
