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

  // Constants for roles
  static const String ROLE_CUSTOMER = "CUSTOMER";
  static const String ROLE_PROVIDER = "PROVIDER";

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
      case "cashreceived":
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

  void handleCardTap(AppointmentModel2 appointment) {
    try {
      final role = controller.userRole.value.toUpperCase();
      final status = appointment.status.toLowerCase();

      // Provider-specific navigation
      if (role == ROLE_PROVIDER) {
        switch (status) {
          case "pending":
            Get.to(() => Newbookingrequest(), arguments: appointment);
            return;
          case "provider_review_pending":
            Get.to(() => const Providerpaymentsuccessful(),
                arguments: appointment);
            return;
          case "in_progress":
            Get.to(() => Providertotalduration(), arguments: appointment);
            return;
          case "work_completed":
          case "awaiting_payment":
          case "cashpayment":
            Get.to(() => const ConfirmPaymentpage(), arguments: appointment);
            return;
        }
      }

      // Customer-specific navigation
      if (role == ROLE_CUSTOMER) {
        switch (status) {
          case "customer_review_pending":
            Get.to(() => const Providerpaymentsuccessful(),
                arguments: appointment);
            return;
          case "cashpayment":
            Get.to(() => Paywithcash(), arguments: appointment);
            return;
          case "awaiting_payment":
          case "work_completed":
            Get.to(() => Paymentpage(), arguments: appointment);
            return;
          case "accepted":
          case "in_progress":
            Get.to(() => JobPage(), arguments: appointment);
            return;
        }
      }

      // Common navigation (both roles)
      switch (status) {
        case "review_pending":
          Get.to(() => const Providerpaymentsuccessful(),
              arguments: appointment);
          return;
      }

      // If no navigation matched, optionally show a snackbar
      // Get.snackbar("Info", "No action available for this status");
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to open appointment details",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  Widget buildCard(AppointmentModel2 appointment) {
    final isCustomer = controller.userRole.value == ROLE_CUSTOMER;
    final isPending = appointment.status.toLowerCase() == "pending";

    return GestureDetector(
      onTap: () => handleCardTap(appointment),
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
                      Text(
                        appointment.displayName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        appointment.date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        appointment.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    appointment.statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                    onTap: () {
                      Get.to(
                        () => Cancelbooking(),
                        arguments: appointment.id,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
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

  Widget buildSection(String title, List<String> types) {
    final filteredAppointments = controller.appointments
        .where((a) => types.contains(a.status.toLowerCase()))
        .toList();

    if (filteredAppointments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
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
              ? Stack(
                  children: [
                    ListView(),
                    const Center(
                      child: Text("No appointments found."),
                    ),
                  ],
                )
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
                        "cashpayment",
                      ]),
                      buildSection("Review", [
                        "review_pending",
                        "provider_review_pending",
                        "customer_review_pending",
                      ]),
                      buildSection("Completed", ["completed", "cashreceived"]),
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
