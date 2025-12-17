import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../../../Sign _up/otp_purpose.dart';

class EnterEmailController extends GetxController {
  final emailController = TextEditingController();
  final ApiClient apiClient = Get.find<ApiClient>();

  bool isLoading = false;

  /// Gmail validation
  bool _isValidGmail(String email) {
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+');
    return gmailRegex.hasMatch(email);
  }

  /// ================= LOGIN → SEND OTP =================
  Future<void> onNextPressed() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _error("Email required");
      return;
    }

    if (!_isValidGmail(email)) {
      _error("Please enter a valid Gmail address");
      return;
    }

    isLoading = true;
    update();

    /// 🔥 BACKEND LOGIN REQUEST BODY
    final body = {
      "email": email,
    };

    debugPrint("📤 LOGIN OTP REQUEST => $body");

    final response = await apiClient.postData(
      ApiConstant.login, // 🔥 LOGIN API
      body,
      needToken: false,
    );

    isLoading = false;
    update();

    debugPrint("📥 STATUS => ${response.statusCode}");
    debugPrint("📥 RESPONSE => ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      /// OTP PAGE এ পাঠানো
      Get.toNamed(
        AppRoute.verifyotppageS,
        arguments: {
          "email": email,
          "purpose": OtpPurpose.loginOtp.value,
        },
      );
    } else {
      _error(
        response.body?['message'] ?? "Failed to send login OTP",
      );
    }
  }

  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
