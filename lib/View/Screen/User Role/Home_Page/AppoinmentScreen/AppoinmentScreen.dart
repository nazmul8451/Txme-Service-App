import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Service Provider Role/MyBooking/CancelBooking/CancelBooking.dart';
import '../../../Service Provider Role/MyBooking/NewBookingRequest/NewBookingRequest.dart';
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

  Widget buildCard(appointment) {
    final isCustomer = controller.userRole.value == "CUSTOMER";
    final isProvider = controller.userRole.value == "PROVIDER";
    final isPending = appointment.status.toLowerCase() == "pending";

    return GestureDetector(
      onTap: () {
        if (isProvider) {
          Get.to(() => Newbookingrequest(), arguments: appointment);
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
            /// ================= TOP ROW =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: appointment.image.isNotEmpty
                      ? NetworkImage(appointment.image)
                      : null,
                  child: appointment.image.isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME
                      Text(
                  appointment.displayName,
                  style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      /// DATE
                      Text(
                        appointment.date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      /// DESCRIPTION
                      Text(
                        appointment.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                /// STATUS BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 6.h),
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

            /// ================= CUSTOMER BUTTONS =================
            if (isCustomer && isPending)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// Pending Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.A7DFF,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    /// Cancel Button
                    GestureDetector(
                      onTap: () {
                        Get.to(
                              () => Cancelbooking(),
                          arguments: appointment,
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }



  Widget buildSection(String title, String type) {
    return Obx(() {
      final items = controller.filter(type);
      if (items.isEmpty) return SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          ...items.map(buildCard),
          SizedBox(height: 20.h),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointments")),
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
