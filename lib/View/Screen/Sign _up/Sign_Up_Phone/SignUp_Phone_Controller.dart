import 'dart:convert';
import 'package:country_picker/country_picker.dart'; // ✅ ADDED
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

  // ✅ ADDED: For Country Picker
  final selectedCountryCode = "+1".obs;
  final selectedCountryFlag = "🇺🇸".obs;

  // ✅ ADDED: Function to show country picker
  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        selectedCountryCode.value = "+${country.phoneCode}";
        selectedCountryFlag.value = country.flagEmoji;
      },
    );
  }

  Future<void> sendPhoneOtp() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar("", "Please enter a phone number.");
      return;
    }

    isLoading.value = true;

    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      if (token.isEmpty) {
        Get.snackbar("", "Authentication error. Please log in again.");
        isLoading.value = false;
        return;
      }

      // ✅ UPDATED: Combine country code and phone number
      final fullPhoneNumber = "${selectedCountryCode.value}${phoneController.text}";
      final body = {'phone': fullPhoneNumber};

      debugPrint("🚀 Sending Phone OTP Request...");
      debugPrint("   URL: ${ApiConstant.baseUrl}${ApiConstant.signUpSendPhoneOtp}");
      debugPrint("   Body: $body");

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.signUpSendPhoneOtp}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint("✅ Phone OTP Response Status: ${response.statusCode}");
      debugPrint("   Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(
          AppRoute.verifyotppageS,
          arguments: {
            'phone': fullPhoneNumber, // Pass full phone number
            'purpose': OtpPurpose.phoneVerify.value,
            'channel': OtpChannel.phone.value,
          },
        );
      } else {
        final errorBody = json.decode(response.body);
        Get.snackbar("Verification Failed", errorBody['message'] ?? "Could not send OTP.");
      }
    } catch (e) {
      debugPrint("❌ Phone OTP Exception: $e");
      Get.snackbar("", "An unexpected error occurred.");
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
