import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../../Utils/StaticString/static_string.dart';
import 'FingerprintController.dart';

class Verifyfingerprint extends StatelessWidget {
  Verifyfingerprint({super.key});

  final controller = Get.put(FingerprintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.gray,

        title:   Center(
          child: Text(
            AppString.signIn.tr,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black900,
            ),
          ),
        ),
        elevation: 0,
      ),
      body:  Obx(
        () => Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),


            ///  Fingerprint (animated)
            GestureDetector(
              onTap: controller.onFingerprintPressed,
              child: AnimatedScale(
                scale: controller.isScanning.value ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 600),
                child: SvgPicture.asset(
                  AppIcons.fingerPrint,
                  height: 52.h,
                  width: 52.w,
                  color: controller.isScanning.value
                      ? AppColors.red601
                      : AppColors.black900,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            CustomButton(
              height: 44.h,
              width: 226.w,
              BoxDecoration: BoxDecoration(
                color: AppColors.red601,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  controller.isScanning.value
                      ? "scanning"
                      : AppString.verifyFingerprint.tr,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.FFFFFF,
                  ),
                ),
              ),
              onTap: controller.onFingerprintPressed,
            ),
          ],
        ),
      ),
    ),
    ),

    );
  }
}

