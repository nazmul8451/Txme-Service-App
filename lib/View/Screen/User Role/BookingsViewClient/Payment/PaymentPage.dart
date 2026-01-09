import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../Home_Page/AppoinmentScreen/AppointmentsController.dart';
import '../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import 'Onlinepayment/Onlinepayment.dart';
import 'PaymentPageController.dart';
import 'PaywithWallet/PaywithWallet.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  final Paymentpagecontroller controller = Get.put(Paymentpagecontroller());
  final AppointmentsController appController = Get.find<AppointmentsController>();
  late final AppointmentModel2 appointment;

  late SocketApi socketApi;
  late String eventName;
  Worker? appointmentWorker;

  @override
  void initState() {
    super.initState();
    appointment = Get.arguments as AppointmentModel2;

    // ✅ Initialize socket properly
    try {
      socketApi = Get.find<SocketApi>();
    } catch (e) {
      socketApi = SocketApi();
      Get.put(socketApi);
    }

    eventName = "appointmentUpdate::${appController.userId.value}";

    _listenSocket();
    _listenAppointmentChanges();
  }

  // ✅ Socket listener
  void _listenSocket() {
    debugPrint("🔌 Socket listening to: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📡 PaymentPage received socket update: $data");
      appController.loadData(silent: true);
    });
  }

  // ✅ Listen to appointment status changes
  void _listenAppointmentChanges() {
    appointmentWorker = ever(
      appController.appointments,
          (List<AppointmentModel2> list) {
        final updated = list.firstWhereOrNull((e) => e.id == appointment.id);
        if (updated != null) {
          final status = updated.status.toLowerCase();

          debugPrint("📊 Appointment status changed to: $status");

          // ✅ Navigate when cash is received
          if (status == "cashreceived" ||
              status == "review_pending" ||
              status == "customer_review_pending") {

            // Stop polling if running
            controller.stopPolling();

            debugPrint("✅ Payment confirmed, navigating...");

            Get.off(
                  () => const Providerpaymentsuccessful(),
              arguments: updated,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    debugPrint("🔌 Removing socket listener: $eventName");
    socketApi.off(eventName);
    appointmentWorker?.dispose();
    super.dispose();
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
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 70.w),
          child: Text(
            "Payment",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1F2937),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Total Amount Card
              Container(
                width: 353.w,
                height: 166.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        "Total Amount Due",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff1F2937),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                      style: TextStyle(
                        fontSize: 50.sp,
                        color: const Color(0xff2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      appointment.date,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff4C545F),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Job Details
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xffFF5A36), width: 1.w),
                ),
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
                            color: const Color(0xff1F2937),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Service:",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1F2937),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Date:",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1F2937),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Name:",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1F2937),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 12.h),
                          Text(
                            appointment.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff4C545F),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            appointment.date,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff4C545F),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            appointment.displayName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff4C545F),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Invoice Breakdown
              Container(
                width: 351.w,
                height: 173.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xffFF5A36), width: 1.w),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, right: 160.w),
                      child: Text(
                        "Invoice Breakdown",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1F2937),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
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
                              color: const Color(0xff4C545F),
                            ),
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
                    SizedBox(height: 12.h),
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
                              color: const Color(0xff4C545F),
                            ),
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
                    SizedBox(height: 9.h),
                    Container(
                      width: 331.w,
                      height: 1.h,
                      color: const Color(0xff4C545F),
                    ),
                    SizedBox(height: 12.h),
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
                              color: const Color(0xff1F2937),
                            ),
                          ),
                          Text(
                            "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff3A7DFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Pay With Cash Button
              Obx(() => GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : () {
                  controller.acceptBooking(appointment.id);
                },
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: controller.isLoading.value
                        ? Colors.grey
                        : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.isLoading.value
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : const Text(
                    "Pay With Cash",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),

              SizedBox(height: 22.h),

              // Online Payment Button
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xff3A7DFF),
                ),
                child: const Center(
                  child: Text(
                    "Online payment",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
                onTap: () {
                  Get.off(
                        () => Onlinepayment(),
                    arguments: appointment,
                  );
                },
              ),

              SizedBox(height: 22.h),

              // Pay with Wallet Button
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xffFF5A36),
                ),
                child: const Center(
                  child: Text(
                    "Pay with Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
                onTap: () {
                  Get.off(
                        () => Paywithwallet(),
                    arguments: appointment,
                  );
                },
              ),

              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}