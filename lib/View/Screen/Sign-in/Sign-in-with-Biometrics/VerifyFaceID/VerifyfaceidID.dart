import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import 'face_id_controller.dart';

class VerifyFaceId extends StatelessWidget {
  VerifyFaceId({super.key});

  final controller = Get.put(FaceIdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
            () => Stack(
          alignment: Alignment.center,
          children: [
            /// Camera Preview
            controller.isCameraInitialized.value
                ? CameraPreview(controller.cameraController!)
                : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

            /// Face Detection Circle
            Container(
              width: 280.w,
              height: 280.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 6.w,
                ),
              ),
              child: CircularProgressIndicator(
                value: controller.faceProgress.value,
                strokeWidth: 4.w,
                valueColor: const AlwaysStoppedAnimation(
                  Colors.lightBlueAccent,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),

            ///  Bottom Button (DESIGN SAME)
            Positioned(
              bottom: 10.h,
              left: 20.w,
              right: 20.w,
              child: CustomButton(
                height: 55.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  color: AppColors.red601,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.faceIdScan,
                      color: AppColors.FFFFFF,
                      height: 22.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppString.authenticateFaceID.tr,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.FFFFFF,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: controller.onAuthenticatePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

