import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppImg/app_img.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../Widgegt/Custom_Button/custom_button.dart';
import '../Availablebalance/Availablebalance.dart';
import 'TopUpController.dart';

class Topuppage extends StatefulWidget {
  Topuppage({Key? key}) : super(key: key);

  @override
  State<Topuppage> createState() => _TopuppageState();
}

class _TopuppageState extends State<Topuppage> {

  final Topupcontroller controller = Get.put(Topupcontroller());

  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AppIcons.chevronleft),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card

              Availablebalance(),

              SizedBox(height: 20.sp),

              // Amount Input
              Text(
                "Enter Amount",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4C545F),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.ammountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(hint: "€0.00"),
              ),
              SizedBox(height: 20.h),

              // Message Input
              TextField(
                controller: controller.messageController,
                decoration: _inputDecoration(hint: "Note(Optional)"),
              ),
              SizedBox(height: 20.h),

              Text(
                "Select Payment method ",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4C545F),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(height: 12.h),

              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  color: AppColors.FFFFFF,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: selectedIndex == 2 ? AppColors.red601 : Color(0xffCACACA),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppImg.stripePayment,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Stripe Payment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff4C545F),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          color: selectedIndex == 2 ? AppColors.red601 : Color(0xffCACACA),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 2; // Stripe selected
                  });
                },

              ),

              SizedBox(height: 15.h),


              // Add New Card Button
              CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  color: AppColors.red601,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Obx(() {
                    return controller.isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.FFFFFF,
                      ),
                    );
                  }),
                ),
                onTap: () {
                  ///  Prevent double click
                  if (controller.isLoading.value) return;

                  ///  Amount empty
                  if (controller.ammountController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter amount");
                    return;
                  }

                  ///  Amount invalid
                  final amount =
                  int.tryParse(controller.ammountController.text.trim());
                  if (amount == null || amount <= 0) {
                    Get.snackbar("Error", "Invalid amount");
                    return;
                  }

                  ///  Payment method not Stripe
                  if (selectedIndex != 2) {
                    Get.snackbar("Error", "Please select Stripe payment");
                    return;
                  }

                  ///  Everything OK → Stripe flow
                  controller.createPaymentIntent();
                },
              ),

            ],
          )),
        ),
    );
  }

  Widget buildPaymentButton(
      {required int index, required String iconPath, required String title}) {
    return Obx(
          () => CustomButton(
        height: 56.h,
        width: 353.w,
        BoxDecoration: BoxDecoration(
          color: AppColors.FFFFFF,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: controller.selectedPaymentIndex.value == index
                ? AppColors.red601
                : Color(0xffCACACA),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(iconPath, height: 25, width: 25),
                  SizedBox(width: 4.w),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4C545F)),
                  ),
                ],
              ),
              Container(
                height: 9,
                width: 9,
                decoration: BoxDecoration(
                  color: controller.selectedPaymentIndex.value == index
                      ? AppColors.red601
                      : Color(0xffCACACA),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              )
            ],
          ),
        ),
            onTap: () {
              controller.createPaymentIntent();
            },
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
