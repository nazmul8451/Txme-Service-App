import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/FourArcLoader.dart';
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
      case "accepted":
        return Colors.blue;
      case "in_progress":
        return Colors.orange;
      case "work_completed":
        return Colors.deepOrange;
      case "completed":
        return Colors.green.shade700;
      case "awaiting_payment":
        return Colors.purple;
      case "cashpayment":
        return Colors.indigo;
      case "cashReceived":
        return Colors.green;
      case "review_pending":
      case "provider_review_pending":
      case "customer_review_pending":
        return Colors.teal;
      case "cancelled":
      case "rejected":
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

        if (role == "PROVIDER" && status == "pending") {
          Get.to(() => Newbookingrequest(), arguments: appointment);
          return;
        }
        if (role == "PROVIDER" && status == "provider_review_pending") {
          Get.to(() => const Providerpaymentsuccessful(), arguments: appointment);
          return;
        }
        if (role == "CUSTOMER" && status == "customer_review_pending") {
          Get.to(() => const Providerpaymentsuccessful(), arguments: appointment);
          return;
        }
        if (status == "accepted") {
          Get.to(() => JobPage(), arguments: appointment);
          return;
        }
        if (status == "review_pending") {
          Get.to(() => const Providerpaymentsuccessful(), arguments: appointment);
          return;
        }
        if (role == "CUSTOMER" && status == "cashpayment") { // Corrected from cashPayment to cashpayment
          Get.to(() => Paywithcash(), arguments: appointment);
          return;
        }
        if (role == "CUSTOMER" && status == "awaiting_payment") {
          Get.to(() => Paymentpage(), arguments: appointment);
          return;
        }
        if (status == "awaiting_payment") {
          if (role == "CUSTOMER") {
            Get.to(() => Paymentpage(), arguments: appointment);
          } else if (role == "PROVIDER") {
            Get.to(() => const ConfirmPaymentpage(), arguments: appointment);
          }
          return;
        }

        if (status == "cashpayment") {
          if (role == "PROVIDER") {
            Get.to(() => const ConfirmPaymentpage(), arguments: appointment);
          }
          return;
        }

        if (status == "in_progress") {
          if (role == "CUSTOMER") {
            Get.to(() => JobPage(), arguments: appointment);
          } else if (role == "PROVIDER") {
            Get.to(() => Providertotalduration(), arguments: appointment);
          }
          return;
        }
        if (status == "work_completed") {
          if (role == "CUSTOMER") {
            Get.to(() => Paymentpage(), arguments: appointment);
          } else if (role == "PROVIDER") {
            Get.to(() => const ConfirmPaymentpage(), arguments: appointment);
          }
          return;
        }
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: appointment.image.isNotEmpty
                      ? NetworkImage(appointment.image)
                      : null,
                  child: appointment.image.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.displayName,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.h),
                      Text(appointment.date,
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.black54)),
                      SizedBox(height: 4.h),
                      Text(appointment.description,
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.black87)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    appointment.statusText, // ✅ USE UI TEXT
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (isCustomer && isPending)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: GestureDetector(
                    onTap: () => Get.to(() => Cancelbooking(),
                        arguments: appointment.id),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text("Cancel",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<String> types) {
    final filteredAppointments = controller.appointments
        .where((a) => types.contains(a.status.toLowerCase()))
        .toList();

    if (filteredAppointments.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        ),
        ...filteredAppointments.map(buildCard).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        surfaceTintColor: AppColors.FFFFFF,
        title: const Text("Appointments"),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.appointments.isEmpty) {
          return const FourArcLoader();
        }
        return RefreshIndicator(
          onRefresh: () => controller.loadData(),
          color: AppColors.A7DFF,
          backgroundColor: Colors.white,
          child: controller.appointments.isEmpty
              ? Stack(children: [
                  ListView(),
                  const Center(child: Text("No appointments found."))
                ])
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      buildSection("Pending", ["pending"]),
                      buildSection("Confirmed", [
                        "accepted",
                        "in_progress",
                        "work_completed",
                        "awaiting_payment",
                        "cashpayment" // Corrected from cashPayment to cashpayment
                      ]),
                      buildSection("Review", [
                        "review_pending",
                        "provider_review_pending",
                        "customer_review_pending"
                      ]),
                      buildSection("Completed", ["completed"]),
                      buildSection("Cancelled", ["cancelled", "rejected"]),
                    ],
                  ),
                ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
