import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../otp_purpose.dart';


class SignUpPhoneController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendPhoneOtp() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar("", "Please enter a phone number.");
      return;
    }

    isLoading.value = true;

    try {
      final userId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
      if (userId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please log in again.");
        return;
      }

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.signUpSendPhoneOtp}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': userId,
          'phone': phoneController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(
          AppRoute.verifyotppageS,
          arguments: {
            'email': "", // Not needed for phone verification, but good to pass consistently
            'purpose': OtpPurpose.phoneVerify.value,
          },
        );
      } else {
        final errorBody = json.decode(response.body);
        Get.snackbar("Verification Failed", errorBody['message'] ?? "Could not send OTP.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
