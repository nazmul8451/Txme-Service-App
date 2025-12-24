import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/CustomBottomNavBar/ProviderNavBar.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/ScheduleBookingPage.dart';
import 'ProviderBookingsController.dart';
import 'ProviderbookingModel.dart';

class ProviderMyBookingsPageUI extends StatelessWidget {
  ProviderMyBookingsPageUI({super.key});

  // Dependency injection: Controller alada page theke
  final controller = Get.put(ProviderBookingsController());

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "started":
        return const Color(0xff42d589);
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget buildBookingCard(ProviderbookingModel booking) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const BookingSchedulePage());
      },
      child: Container(
        width: 353.w,
        height: 120.h,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 25.r, backgroundImage: NetworkImage(booking.image)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    booking.name,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff4C545F)),
                  ),
                  SizedBox(height: 10.h),
                  Text(booking.date,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                  SizedBox(height: 10.h),
                  Text(booking.service,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 13.h),
              child: Container(
                width: 64.w,
                height: 23.h,
                decoration: BoxDecoration(
                    color: getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(8.r)),
                child: Center(
                  child: Text(booking.status,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<ProviderbookingModel> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        ...bookings.map(buildBookingCard).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(AppIcons.chevronleft)),
        title: GestureDetector(
          onTap: (){

            Get.toNamed(AppRoute.newbookingrequest);

          },
          child: Text("My Booking",
              style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.currentJob.isNotEmpty)
                buildSection("Current Job", controller.currentJob),
              if (controller.pending.isNotEmpty)
                buildSection("Pending", controller.pending),
              if (controller.completed.isNotEmpty)
                buildSection("Completed", controller.completed),
              if (controller.currentJob.isEmpty &&
                  controller.pending.isEmpty &&
                  controller.completed.isEmpty)
                Center(
                    child: Text("No bookings found",
                        style: TextStyle(fontSize: 14.sp))),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
      //bottomNavigationBar: CustomProvidernavbar(selectedIndex: 1),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
