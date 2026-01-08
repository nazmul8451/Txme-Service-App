import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'SignUp_Phone_Controller.dart';

class SignUpPhone extends StatefulWidget {
  const SignUpPhone({super.key});

  @override
  State<SignUpPhone> createState() => _SignUpPhoneState();
}

class _SignUpPhoneState extends State<SignUpPhone> {
  final controller = Get.put(SignUpPhoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        title: Center(
          child: Text(
            AppString.signUn.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Center(
              child: Image.asset(AppImg.image15, height: 120.h, width: 120.w),
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            // ✅ UPDATED: Added Country Code Picker UI
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.pickCountry(context),
                    child: Obx(() => Row(
                      children: [
                        Text(controller.selectedCountryFlag.value, style: TextStyle(fontSize: 24.sp)),
                        SizedBox(width: 8.w),
                        Text(controller.selectedCountryCode.value, style: TextStyle(fontSize: 16.sp)),
                        const Icon(Icons.arrow_drop_down)
                      ],
                    )),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            height: 56.h,
            width: 353.w,
            BoxDecoration: BoxDecoration(
              color: AppColors.red601,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() => Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                AppString.verifyNumber.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.FFFFFF,
                ),
              ),
            )),
            onTap: () => controller.isLoading.value ? null : controller.sendPhoneOtp(),
          ),
        ],
      ),
    );
  }
}
