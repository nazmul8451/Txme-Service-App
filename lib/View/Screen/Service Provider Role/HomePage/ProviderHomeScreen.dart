import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../User Role/Home_Page/AppoinmentScreen/AppointmentsController.dart';
import '../../User Role/Home_Page/NotificationPage/NotificationPage.dart';
import '../../Wallet/Availablebalance/Availablebalance.dart';
import '../MyBooking/CancelBooking/CancelBooking.dart';
import '../MyBooking/NewBookingRequest/NewBookingRequest.dart';
import 'ProviderHomeController.dart';
import '../../Wallet/Availablebalance/WalletController.dart';




class ProviderHomeScreen extends StatelessWidget {
  final ProviderHomeController controller = Get.put(ProviderHomeController());

  final appointmentController = Get.put(AppointmentsController());

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

  ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.red601,
        onRefresh: () async {
          final walletController = Get.find<WalletControllerA>();
          await Future.wait([
            controller.fetchCurrentAppointmentStatus(),
            appointmentController.loadData(),
            walletController.getAvailableBalance(),
            controller.fetchUnreadNotificationCount(), // Refresh notification count
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding:  EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  
               SizedBox(height: 30.h,),
  
              /// ------------------ HEADER ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => RichText(
                    text: TextSpan(
                      style:  TextStyle(color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w700),
                      children: [
                        const TextSpan(text: 'Welcome '),
                        TextSpan(
                          text: controller.name.value,
                          style:  TextStyle( fontSize: 24.sp,  fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => NotificationPage());
                    },
                    child: Obx(() => Stack(
                      clipBehavior: Clip.none,
                      children: [
                         Icon(Icons.notifications_none, size: 30.w),
                        if(controller.notificationCount.value > 0)
                          Positioned(
                            right: -1.w,
                            top: -1.h,
                            child: Container(
                              height: 16.h,
                              width: 16.w,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  controller.notificationCount.value.toString(),
                                  style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
               SizedBox(height: 30.h,),
  
              /// 1. Offer a Service Button
              GestureDetector(
                onTap: () {
                 Get.toNamed(AppRoute.profession);
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A36),
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  alignment: Alignment.center,
                  child:  Text(
                    "Offer a Service",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
  
               SizedBox(height: 21.h),
  
              /// 2. Balance Card
              Availablebalance(),
  
               SizedBox(height: 20.h),
  
              /// 3. Promotion Card
              Align(
                child: Container(
                  width: 353.w,
                  height: 189.h,
                  padding:  EdgeInsets.all(14.0.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child:  Text(
                          "Boost your visibility with Txme!",
                          style: TextStyle(
                            fontSize: 21.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4C545F)
                          ),
                        ),
                      ),
                       SizedBox(height: 5.0.h),
                      Padding(
                        padding:  EdgeInsets.all(16.0.w),
                        child:  Text(
                          "Get your service listed at the top of search"
                              " results for just € 1 per day!",
                
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff333333)
                          ),
                        ),
                      ),
                       SizedBox(height: 12.0.h),
                      Center(
                        child: SizedBox(
                          width: 253.w,
                          height: 45.h.clamp(45, 46),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red601,
                              padding:  EdgeInsets.symmetric(vertical: 12.0.h.clamp(12, 14)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0.r),
                              ),
                            ),
                            onPressed: () {},
                            child:  Text(
                              "Advertise your service Today",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.FFFFFF,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
  
  
               SizedBox(height: 20.h),
  
  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Job",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.gray900),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoute.appointmentsPage);
                    },
                    child: Text(
                      AppString.viewAll.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.A7DFF),
                    ),
                  ),
                ],
              ),
  
               SizedBox(height: 20.h),
  
              /// ------------------ UPCOMING APPOINTMENTS ------------------
              Obx(() {
                if (appointmentController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
  
                final pendingAppointments = appointmentController.appointments
                    .where((e) => e.status == "pending")
                    .take(3)
                    .toList();
  
                if (pendingAppointments.isEmpty) {
                  return const SizedBox();
                }
  
                return Column(
                  children: pendingAppointments
                      .map((appointment) => _buildCard(appointment))
                      .toList(),
                );
              }),
  
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildCard(AppointmentModel2 appointment) {
    final isCustomer = appointmentController.userRole.value == "CUSTOMER";
    final isProvider = appointmentController.userRole.value == "PROVIDER";
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
                    color:getStatusColor(appointment.status),
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
                        appointment.status.toUpperCase(),
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

}
