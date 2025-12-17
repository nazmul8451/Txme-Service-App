import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Screen/splashScreen/splash_screen_controller.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

class SplashScreenView extends StatelessWidget {
   SplashScreenView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      body: Padding(
        padding: EdgeInsets.all(20.w), //  responsive only
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 232.h), //  same value
                child: SizedBox(
                  height: 164.h,
                  width: 353.w,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImg.image15,
                        height: 120.h,
                        width: 120.w,
                      ),
                      Text(
                        AppString.txmeRecaim.tr, //  localization only
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp, //  responsive
                          fontWeight: FontWeight.w400,
                          color: AppColors.black800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 42.h),

              CustomButton(
                onTap: () {
                  controller.onGetStarted();
                },
                height: 40.h,
                width: 167.w,
                BoxDecoration: BoxDecoration(
                  color: AppColors.red601,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    AppString.getStarted.tr, //  localization
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp, //  responsive
                      fontWeight: FontWeight.w700,
                      color: AppColors.FFFFFF,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
