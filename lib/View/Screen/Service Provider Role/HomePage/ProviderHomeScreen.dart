import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';

import '../../../../Utils/AppImg/app_img.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../User Role/Home_Page/NotificationPage/NotificationPage.dart';
import 'ProviderHomeController.dart';




class ProviderHomeScreen extends StatelessWidget {
  final ProviderHomeController controller = Get.put(ProviderHomeController());

  ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                      const TextSpan(text: 'Welcome, '),
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
                // এখানে আপনার Logic লিখতে পারবেন
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
            Container(
              width: 353.w,
              height: 148.h,
              padding:  EdgeInsets.all(20.0.w),
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(8.r),

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  Text(
                    "Earning This Week",
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      color: Color(0xff1F2937),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  Text(
                    "€1,250.00",
                    style: TextStyle(
                      fontSize: 40.0.sp.clamp(40, 45),
                      color: Color(0xff1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

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
            Container(
              width: 353.w,
              height: 144.h,
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  /// LEFT TEXT AREA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Text(
                            "Tomorrow, 10:00 AM",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff7C7D7E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h, left: 20.w),
                          child: Text(
                            "Home Cleaning",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff1D1D1D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h, left: 20.w),
                          child: Text(
                            "With Sarah Miller",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff7C7D7E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT IMAGE
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          AppImg.ellipse,
                          height: 80.h,
                          width: 80.w,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),
             SizedBox(height: 12.h),
            Container(
              width: 353.w,
              height: 144.h,
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  /// LEFT TEXT AREA
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Text(
                            "Tomorrow, 10:00 AM",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff7C7D7E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h, left: 20.w),
                          child: Text(
                            "Home Cleaning",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff1D1D1D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.only(top: 12.h, left: 20.w),
                          child: Text(
                            "With Sarah Miller",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff7C7D7E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT IMAGE
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          AppImg.ellipse,
                          height: 80.h,
                          width: 80.w,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
