import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true, //  back enabled
        title: Text(
          AppString.signIn.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black900,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(
            () => AnimatedScale(
          scale: controller.isScanning.value ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 500),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.fingerPrint,
              height: 60.h,
              width: 60.w,
              color: controller.isScanning.value
                  ? AppColors.red601
                  : AppColors.black900,
            ),
          ),
        ),
      )

    );
  }
}
