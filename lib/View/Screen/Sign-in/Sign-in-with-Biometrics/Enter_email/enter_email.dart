import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/View/Widgegt/Email_Input_Field/EmailInputField.dart';


import 'EnterEmailController.dart';

class EnterEmail extends StatelessWidget {
  EnterEmail({super.key});

  final controller = Get.put(EnterEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 165.h),
                child: Image.asset(
                  AppImg.image15,
                  height: 120.h,
                  width: 120.w,
                ),
              ),
            ),
        
            SizedBox(height: 121.h),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomTextField(
                controller: controller.emailController,
                label: AppString.enterEmaily,
                hint: "Enter email",
                keyboardType: TextInputType.emailAddress,
              ),
            ),
        
            SizedBox(height: 30.h),
        
            CustomButton(
              height: 56.h,
              width: 353.w,
              BoxDecoration: BoxDecoration(
                color: AppColors.red601,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  AppString.next.tr,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.FFFFFF,
                  ),
                ),
              ),
              onTap: () {
                controller.onNextPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
