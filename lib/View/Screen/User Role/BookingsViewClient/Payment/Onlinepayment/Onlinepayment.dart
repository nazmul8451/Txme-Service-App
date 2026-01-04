import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import 'OnlinePaymentController.dart'; // ✅ ADDED

class Onlinepayment extends StatefulWidget {
  const Onlinepayment({super.key});

  @override
  State<Onlinepayment> createState() => _OnlinepaymentState();
}

class _OnlinepaymentState extends State<Onlinepayment> {
  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;
  final OnlinePaymentController controller = Get.put(OnlinePaymentController()); // ✅ ADDED

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
          padding: EdgeInsets.only(left: 45.w),
          child: Text(
            "Select Payment Method",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
          child: SingleChildScrollView(
              child: Column(children: [
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
                        padding:  EdgeInsets.only(top: 12.h),
                        child: Text(
                          "Total Amount Due",
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300, color: const Color(0xff1F2937)),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                         "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                        style:  TextStyle(
                          fontSize: 50.sp,
                          color: const Color(0xff2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text( appointment.date,
                        style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.w300, color: const Color(0xff4C545F)),
                      ),
                    ],
                  ),
                ),
            SizedBox(
              height: 20.h,
            ),
            // ... (Your card widgets can be added back here)
                SizedBox(height: 40.h,),

                GestureDetector(
                  onTap: () => controller.makePayment(appointment),
                  child: Container(
                    height: 56.h,
                    width: 353.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: const Color(0xffFF5A36),
                    ),
                    child: Center(
                      child: Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Make Payment",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xffFFFFFF)),
                      )),
                    ),
                  ),
                ),

          ]))),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
