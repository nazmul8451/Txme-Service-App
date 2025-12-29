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
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../PaymentSuccessful/ProviderPaymentSuccessful.dart';
import 'ConfirmPaymentController.dart';

class ConfirmPaymentpage extends StatelessWidget {
   ConfirmPaymentpage({super.key});

  final Confirmpaymentcontroller controller = Get.put(Confirmpaymentcontroller());

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
            "Confirm Payment",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Did you receive the ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 32.sp,
                    color: Color(0xff1F2937)),
              ),
              Text(
                "payment from the ",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 32.sp,
                    color: Color(0xff1F2937)),
              ),
              Text(
                "client?",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 32.sp,
                    color: Color(0xff1F2937)),
              ),

              Center(
                child: Text(
                  "€ ${appointment.totalCost?.toStringAsFixed(2) ?? '0.00'}",
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFF5A36),
                  ),
                ),
              ),

              SizedBox(height: 8.h,),


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

              CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xffFF5A36),
                  ),
                  child: Center(
                      child: Text(
                    "Yes, I received",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffFFFFFF)),
                  )),

                  onTap: () async {
                    ///  prevent double tap
                    if (controller.isLoading.value) return;

                    final success =
                    await controller.acceptBooking(appointment.id);

                    ///  API SUCCESS → GO TO JOB PAGE
                    if (success) {
                      Get.off(
                            () => Providerpaymentsuccessful(),
                        arguments: appointment, //  FULL MODEL
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to accept booking",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  // onTap: () {
                  //   Get.toNamed(AppRoute.providerpaymentsuccessful);
                  // }


                  ),



              // SizedBox(
              //   height: 22.h,
              // ),
              // CustomButton(
              //     height: 56.h,
              //     width: 353.w,
              //     BoxDecoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12.r),
              //       color: Color(0xff7CA7FC),
              //     ),
              //     child: Center(
              //         child: Text(
              //       "No, payment is pending",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           fontSize: 18,
              //           color: Color(0xffFFFFFF)),
              //     )),
              //     onTap: () {
              //       //Get.toNamed(AppRoute.onlinepayment);
              //     }),
              SizedBox(
                height: 28.h,
              ),
              
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoute.contactsupport);
                },
                child: Text("Need help? Contact support", style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff3A7DFF)
                ),),
              ),

              SizedBox(
                height: 118.h,
              ),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: CustomProvidernavbar(selectedIndex: 1),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
