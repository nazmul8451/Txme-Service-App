import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentsController.dart';

import '../../../../../Utils/AppColors/app_colors.dart' show AppColors;
import '../../../../../Utils/AppIcons/app_icons.dart' show AppIcons;
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart' show CustomButton;
import '../../../User Role/BookingsViewClient/JobStartedPage/JobProgressPage/JobProgressPage.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../CancelBooking/CancelBooking.dart';
import 'NewBookingRequestController.dart';

class Newbookingrequest extends StatefulWidget {
  const Newbookingrequest({super.key});

  @override
  State<Newbookingrequest> createState() => _NewbookingrequestState();
}

class _NewbookingrequestState extends State<Newbookingrequest> {
  final appController = Get.find<AppointmentsController>();
  late String appointmentId;

  @override
  void initState() {
    super.initState();
    final AppointmentModel2 initialAppointment = Get.arguments as AppointmentModel2;
    appointmentId = initialAppointment.id;
    
    // Listen for changes
    ever(appController.appointments, (List<AppointmentModel2> list) {
      final updated = list.firstWhereOrNull((e) => e.id == appointmentId);
      if (updated != null) {
        final status = updated.status.toLowerCase();
        if (status == "cancelled" || status == "rejected") {
           Get.back();
           Get.snackbar("Notice", "This booking request was cancelled by the customer.");
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

  final NewBookingRequestController controller = Get.put(NewBookingRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              AppIcons.chevronleft,
              height: 24.h, // Fixed height/width (80 was way too big)
              width: 24.w,
            )),
        title: const Text("New Booking Request",
              style: TextStyle(color: Colors.black, fontSize: 18)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        final appointment = appController.appointments.firstWhereOrNull((e) => e.id == appointmentId) 
                            ?? (Get.arguments as AppointmentModel2);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Center(child: SvgPicture.asset(AppIcons.group)),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Booking Request",
                  style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1F2937)),
                ),
                Text(
                  "from ${appointment.description} Services",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff4C545F),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 353.w,
                  height: 107.h,
                  decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xff3A7DFF), width: 1.w)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 29.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.date,
                              height: 24.h,
                              width: 24.w,
                            ),
                            SizedBox(
                              width: 13.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date & Time",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff333333)),
                                ),
                                Text(
                                  appointment.date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.sp,
                                      color: const Color(0xff4C545F)),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                const Text("Is this time available?",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff4C545F))),
                SizedBox(
                  height: 20.h,
                ),
                CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xffFF5A36),
                  ),
                  child: controller.isLoading.value
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : const Center(
                    child: Text(
                      "Confirm",
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
                            () => JobPage(),
                        arguments: appointment, // 🔥 FULL MODEL
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
                  height: 20.h,
                ),
                CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffDA0808), width: 1.w),
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xffFFFFFF),
                    ),
                    child: const Center(
                        child: Text(
                      "Decline Request",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffDA0808)),
                    )),
                    onTap: () {
                      Get.to(
                            () => Cancelbooking(),
                        arguments: appointment.id,
                      );

                    }),
              ],
            ),
          ),
        );
      }),
      // bottomNavigationBar: CustomProvidernavbar(selectedIndex: 1),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
