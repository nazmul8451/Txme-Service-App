import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Service Provider Role/MyBooking/CancelBooking/CancelBooking.dart';
import '../../../Service Provider Role/MyBooking/ConfirmPayment/ConfirmPayment.dart';
import '../../../Service Provider Role/MyBooking/NewBookingRequest/NewBookingRequest.dart';
import '../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import '../../../Service Provider Role/MyBooking/ProviderTotalDuration/ProviderTotalDuration.dart';
import '../../BookingsViewClient/JobStartedPage/JobProgressPage/JobProgressPage.dart';
import '../../BookingsViewClient/Payment/PayWithCash/PayWithCash.dart';
import '../../BookingsViewClient/Payment/PaymentPage.dart';
import 'AppointmentModel/AppointmentModel2.dart';
import 'AppointmentsController.dart';


class AppointmentsPage extends StatelessWidget {
  AppointmentsPage({super.key});
  final controller = Get.put(AppointmentsController());

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return AppColors.A7DFF;
      case "confirmed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildCard(AppointmentModel2 appointment) {
    final isCustomer = controller.userRole.value == "CUSTOMER";
    final isPending = appointment.status.toLowerCase() == "pending";

    return GestureDetector(
      onTap: () {
        final role = controller.userRole.value.toUpperCase();
        final status = appointment.status.toLowerCase();

        /// 🔹 PROVIDER + PENDING
        if (role == "PROVIDER" && status == "pending") {
          Get.to(
                () => Newbookingrequest(),
            arguments: appointment,
          );
          return;
        }

        /// 🔹 BOTH + ACCEPTED
        if (status == "accepted") {
          Get.to(
                () => JobPage(),
            arguments: appointment,
          );
          return;
        }

        if (status == "cashReceived") {
          Get.to(
                () => Providerpaymentsuccessful(),
            arguments: appointment,
          );
          return;
        }

        if (role == "CUSTOMER" && status == "cashPayment") {
          Get.to(
                () => Paywithcash(),
            arguments: appointment,
          );
          return;
        }

        if (role == "CUSTOMER" && status == "awaiting_payment") {
          Get.to(
                () => Paymentpage(),
            arguments: appointment,
          );
          return;
        }

        /// 🔹 BOTH + IN_PROGRESS
        if (status == "in_progress") {
          /// 👤 CUSTOMER → JobPage
          if (role == "CUSTOMER") {
            Get.to(
                  () => JobPage(),
              arguments: appointment,
            );
          }

          /// 🧑‍🔧 PROVIDER → Providertotalduration
          else if (role == "PROVIDER") {
            Get.to(
                  () => Providertotalduration(),
              arguments: appointment,
            );
          }

          return;
        }





        if (status == "work_completed") {
          /// 👤 CUSTOMER → JobPage
          if (role == "CUSTOMER") {
            Get.to(
                  () => Paymentpage(),
              arguments: appointment,
            );
          }

          /// 🧑‍🔧 PROVIDER → Providertotalduration
          else if (role == "PROVIDER") {
            Get.to(
                  () => ConfirmPaymentpage(),
              arguments: appointment,
            );
          }

          return;
        }


        ///  otherwise do nothing
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: [
            /// TOP ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: appointment.image.isNotEmpty
                      ? NetworkImage(appointment.image)
                      : null,
                  child:
                  appointment.image.isEmpty ? const Icon(Icons.person) : null,
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.displayName,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        appointment.date,
                        style:
                        TextStyle(fontSize: 12.sp, color: Colors.black54),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        appointment.description,
                        style:
                        TextStyle(fontSize: 12.sp, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                /// STATUS
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            /// CUSTOMER CANCEL BUTTON
            if (isCustomer && isPending)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => Cancelbooking(),
                        arguments: appointment.id,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }




  Widget buildSection(String title, String type) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.appointments.isEmpty) {
        return const Center(child: Text("No appointments found"));
      }

      return Column(
        children: controller.appointments
            .map((appointment) => buildCard(appointment))
            .toList(),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
          backgroundColor: AppColors.FFFFFF,
          surfaceTintColor: AppColors.FFFFFF,
          title: Text("Appointments")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            buildSection("Pending", "pending"),
            buildSection("Confirmed", "confirmed"),
            buildSection("Cancelled", "cancelled"),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
