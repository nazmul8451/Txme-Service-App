import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/Utils/StaticString/static_string.dart';
import 'UploadDocuments1Controller.dart';

class Uploaddocuments1 extends StatelessWidget {
  Uploaddocuments1({super.key});

  final controller = Get.put(UploadDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(AppString.Identity),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: GetBuilder<UploadDocumentsController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// FRONT TITLE
                Text(
                  AppString.UploadPassportFront.tr,
                  style: TextStyle(
                    color: AppColors.black700,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.h),

                /// FRONT IMAGE
                GestureDetector(
                  onTap: controller.pickFrontId,
                  child: Container(
                    width: 353.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: controller.frontId == null
                        ? Icon(Icons.camera_alt_outlined, size: 50.sp)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              File(controller.frontId!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// BACK TITLE
                Text(
                  AppString.UploadPassportBack.tr,
                  style: TextStyle(
                    color: AppColors.black700,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.h),

                /// BACK IMAGE
                GestureDetector(
                  onTap: controller.pickBackId,
                  child: Container(
                    width: 353.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: controller.backId == null
                        ? Icon(Icons.camera_alt_outlined, size: 50.sp)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              File(controller.backId!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),

                SizedBox(
                  height: 40.h,
                ),

                /// UPLOAD BUTTON
                CustomButton(
                  height: 56.h,
                  width: 353.w,
                  BoxDecoration: BoxDecoration(
                    color: controller.isUploading.value
                        ? Colors.grey
                        : AppColors.red601,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: controller.isUploading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Center(
                          child: Text(
                            AppString.Upload,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  onTap: controller.isUploading.value
                      ? null
                      : controller.uploadSelectedDocuments,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
