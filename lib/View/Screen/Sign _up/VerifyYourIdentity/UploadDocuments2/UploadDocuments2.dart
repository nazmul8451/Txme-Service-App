import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';

import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'UploadDocuments2Controller.dart';

class Uploaddocuments2 extends StatelessWidget {
  Uploaddocuments2({super.key});

  final controller = Get.put(CompleteProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(AppString.Identity),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 11.w, right: 130.w),
              child: Text(
                AppString.UploadPassportFront.tr,
                style: TextStyle(
                  color: AppColors.black700,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            /// 📷 Camera container
            GetBuilder<CompleteProfileController>(
              builder: (_) {
                return GestureDetector(
                  onTap: () {
                    controller.openCamera();
                  },
                  child: Container(
                    width: 353.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: controller.imageFile == null
                        ? Icon(Icons.camera_alt_outlined, size: 50.sp)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(controller.imageFile!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 34.h),

            /// ⬆ Upload button
            Obx(() {
              return Column(
                children: [
                  CustomButton(
                    height: 56.h,
                    width: 353.w,
                    BoxDecoration: BoxDecoration(
                      color: AppColors.red601,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        AppString.Upload,
                        style: TextStyle(
                          color: AppColors.FFFFFF,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    onTap: () {
                      controller.uploadImage();
                    },
                  ),

                  SizedBox(height: 20.h),

                  /// Bottom loader
                  controller.isUploading.value
                      ? const CircularProgressIndicator()
                      : SizedBox(), /// hidden when false
                ],
              );
            }),

          ],
        ),
      ),
    );
  }
}
