// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:txme_app/Utils/AppImg/app_img.dart';
// import 'package:txme_app/Utils/StaticString/static_string.dart';
// import 'package:txme_app/View/Widgegt/OtpBoxes/OtpBoxes.dart';
//
// import '../../../../Utils/AppColors/app_colors.dart';
// import '../../../../core/App_Routes/app_routes.dart';
// import '../../../Widgegt/Custom_Button/custom_button.dart';
// import 'VerifyOtpController.dart';
//
// class Verifyotppage extends StatelessWidget {
//   Verifyotppage({super.key});
//
//   final controller = Get.put(VerifyOtpController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.FFFFFF,
//       appBar: AppBar(
//         backgroundColor: AppColors.FFFFFF,
//         title: Center(
//           child: Text(
//             AppString.verifyOTP.tr,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w400,
//               fontSize: 18.sp,
//               color: AppColors.black900,
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 36.h),
//             child: Center(
//               child: Image.asset(AppImg.Data_security_27),
//             ),
//           ),
//
//           SizedBox(height: 40.h),
//
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 50.w),
//             child: Text(
//               AppString.otpText.tr,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.black700,
//               ),
//             ),
//           ),
//
//           SizedBox(height: 15.h),
//
//           /// OTP BOXES
//           CustomOtpFields(
//             length: 6,
//             size: 50,
//             spacing: 10,
//             onChanged: controller.onOtpChanged,
//           ),
//
//           SizedBox(height: 46.h),
//
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Obx(
//                   () => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     AppString.receiveCode.tr,
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16.sp,
//                       color: AppColors.black700,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: controller.onResendPressed,
//                     child: Text(
//                       controller.isResending.value
//                           ? "Resending..."
//                           : AppString.Resend.tr,
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16.sp,
//                         color: AppColors.A7DFF,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           SizedBox(height: 46.h),
//
//           /// VERIFY BUTTON
//           Obx(
//                 () => CustomButton(
//               height: 56.h,
//               width: 353.w,
//               BoxDecoration: BoxDecoration(
//                 color: AppColors.red601,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Center(
//                 child: controller.isLoading.value
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                   AppString.Verify.tr,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.FFFFFF,
//                   ),
//                 ),
//               ),
//               onTap: controller.onVerifyPressed,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
