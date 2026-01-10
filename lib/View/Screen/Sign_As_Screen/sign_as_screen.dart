import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppImg/app_img.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'package:txme_app/View/Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../helper/Shared_prefe/shared_prefe.dart' show SharePrefsHelper;

class SignAsScreen extends StatefulWidget {
  const SignAsScreen({super.key});

  @override
  State<SignAsScreen> createState() => _SignAsScreenState();
}

class _SignAsScreenState extends State<SignAsScreen> {
  bool isUserSelected = true;

  Future<void> _onNext() async {
    if (isUserSelected) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        SharePrefsHelper.user,
      );
    } else {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        SharePrefsHelper.provider,
      );
    }

    /// BOTH → SAME SIGN IN PAGE
    Get.toNamed(AppRoute.signUpEmail);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 44.h),
              child: SizedBox(
                width: double.infinity,
                height: 414.h,
                child: Image.asset(
                  AppImg.splashscreen,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Image.asset(AppImg.image15, height: 110.h, width: 110.w),

            Text(
              AppString.txmeRecaim.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray,
              ),
            ),

            Text(
              AppString.joinasa.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray,
              ),
            ),

            SizedBox(height: 20.h),

            /// USER - PROVIDER BUTTONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  /// USER
                  CustomButton(
                    height: 40.h,
                    width: 167.w,
                    BoxDecoration: BoxDecoration(
                      color: isUserSelected
                          ? AppColors.red601
                          : Colors.transparent,
                      border: Border.all(color: AppColors.red601),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    onTap: () {
                      setState(() => isUserSelected = true);
                    },
                    child: Center(
                      child: Text(
                        AppString.customer.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isUserSelected
                              ? AppColors.FFFFFF
                              : AppColors.black900,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 19.w),

                  /// PROVIDER
                  CustomButton(
                    height: 40.h,
                    width: 167.w,
                    BoxDecoration: BoxDecoration(
                      color: !isUserSelected
                          ? AppColors.red601
                          : Colors.transparent,
                      border: Border.all(color: AppColors.red601),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    onTap: () {
                      setState(() => isUserSelected = false);
                    },
                    child: Center(
                      child: Text(
                        AppString.provider.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isUserSelected
                              ? AppColors.black900
                              : AppColors.FFFFFF,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// NEXT BUTTON
            CustomButton(
              height: 56.h,
              width: 353.w,
              BoxDecoration: BoxDecoration(
                color: AppColors.red601,
                borderRadius: BorderRadius.circular(12.r),
              ),
              onTap: _onNext,
              child: Center(
                child: Text(
                  AppString.next.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.FFFFFF,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
