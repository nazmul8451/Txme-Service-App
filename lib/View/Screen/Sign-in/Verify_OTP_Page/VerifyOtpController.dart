// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/App_Routes/app_routes.dart';
//
// class VerifyOtpController extends GetxController {
//   final otpCode = ''.obs;
//   final isLoading = false.obs;
//   final isResending = false.obs;
//
//   /// OTP collect
//   void onOtpChanged(String value) {
//     otpCode.value = value;
//   }
//
//   /// VERIFY BUTTON
//   Future<void> onVerifyPressed() async {
//     if (otpCode.value.length != 6) {
//       _showSnackBar("Please enter 6 digit OTP");
//       return;
//     }
//
//     isLoading.value = true;
//
//     /// 🔥 API CALL PLACE
//     /*
//       await ApiClient.postData(
//         ApiConstant.verifyOtp,
//         {"otp": otpCode.value},
//       );
//     */
//
//     isLoading.value = false;
//
//     Get.toNamed(AppRoute.faceverificationdone);
//   }
//
//   /// RESEND OTP
//   Future<void> onResendPressed() async {
//     if (isResending.value) return;
//
//     isResending.value = true;
//
//     /// 🔥 API CALL PLACE
//     /*
//       await ApiClient.postData(
//         ApiConstant.resendOtp,
//         {},
//       );
//     */
//
//     await Future.delayed(const Duration(seconds: 2));
//     isResending.value = false;
//
//     Get.snackbar(
//       "Success",
//       "OTP resent successfully",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(16),
//     );
//   }
//
//   void _showSnackBar(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.black87,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(16),
//     );
//   }
// }
