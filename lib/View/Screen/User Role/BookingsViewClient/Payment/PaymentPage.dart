import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import 'PaymentPageController.dart';
import 'PaymentSuccessful/PaymentSuccessful.dart';
import 'PaywithWallet/PaywithWallet.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {

  final Paymentpagecontroller controller =
  Get.put(Paymentpagecontroller());

  final AppointmentModel2 appointment = Get.arguments as AppointmentModel2;

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
          padding: EdgeInsets.only(left: 70.w),
          child: Text(
            "Payment",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 353.w,
                height: 166.h,
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
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
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w300, color: Color(0xff1F2937)),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                      style:  TextStyle(
                        fontSize: 50.sp,
                        color: Color(0xff2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      appointment.date,
                      style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.w300, color: Color(0xff4C545F)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xffFF5A36), width: 1.w)),
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
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "Service:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "Date:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "Name:",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1F2937)),
                        ),
                      ],
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 12.h),
                          Text(
                            appointment.description,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4C545F)),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            appointment.date,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4C545F)),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            appointment.displayName,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4C545F)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 351.w,
                height: 173.h,
                decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xffFF5A36), width: 1.w)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, right: 160.w),
                      child: Text(
                        "Invoice Breakdown",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F2937)),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                                color: Color(0xff4C545F)),
                          ),
                          Text(
                            "${appointment.totalWorkedTime?.toStringAsFixed(1) ?? '0'} hrs",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff1F2937),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
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
                                color: Color(0xff4C545F)),
                          ),
                          Text(
                            "€ ${appointment.hourlyRate?.toStringAsFixed(2) ?? '0.00'}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff1F2937),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Container(
                      width: 331.w,
                      height: 1.h,
                      color: Color(0xff4C545F),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
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
                                color: Color(0xff1F2937)),
                          ),
                          Text(
                            "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3A7DFF)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Obx(() => GestureDetector(
                onTap: () {
                  controller.acceptBooking(appointment.id);
                },
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.isLoading.value
                      ? CupertinoActivityIndicator(color: Colors.white)
                      : const Text(
                    "Pay With Cash",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )),
              SizedBox(
                height: 22.h,
              ),
              CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xff3A7DFF),
                  ),
                  child: Center(
                      child: Text(
                    "Online payment ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffFFFFFF)),
                  )),

                  onTap: () {
                    Get.toNamed(AppRoute.onlinepayment);
                  }
                  ),
              SizedBox(
                height: 22.h,
              ),
              CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xffFF5A36),
                  ),
                  child: Center(
                      child: Text(
                    "Pay with Wallet",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffFFFFFF)),
                  )),
                  onTap: () {
                    Get.off(
                          () => Paywithwallet(),
                      arguments: appointment, //  FULL MODEL
                    );
                  }),
              SizedBox(
                height: 22.h,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
