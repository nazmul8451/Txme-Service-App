import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../otp_purpose.dart';

class VerifyOtpController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  String email = "";
  String channel = "email";
  String purpose = "";
  String biometricType = ""; // ✅ NEW
  String otpCode = "";

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    email = args['email'] ?? "";
    purpose = args['purpose'] ?? "";
    biometricType = args['biometricType'] ?? "";

    debugPrint("📥 OTP PAGE ARGS => $args");
  }

  void onOtpChanged(String value) {
    otpCode = value;
  }

  Future<void> verifyOtp() async {
    if (otpCode.length != 6) {
      _error("Please enter valid OTP");
      return;
    }

    isLoading = true;
    update();

    final body = {
      "purpose": purpose,
      "channel": channel,
      "identifier": email,
      "oneTimeCode": otpCode,
    };

    final response = await apiClient.postData(
      ApiConstant.signUpEmailVerifyOtp,
      body,
      needToken: false,
    );

    isLoading = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await _saveUserData(response.body['data']);
      _handleNavigation();
    } else {
      _error(response.body?['message'] ?? "OTP verification failed");
    }
  }


  /// ================= RESEND OTP =================
  Future<void> resendOtp() async {
    if (email.isEmpty) {
      _error("Email not found");
      return;
    }

    isLoading = true;
    update();

    final body = {
      "identifier": email,
    };

    debugPrint("🔁 RESEND OTP REQUEST => $body");

    final response = await apiClient.postData(
      ApiConstant.resendOtp,
      body,
      needToken: false,
    );

    isLoading = false;
    update();

    debugPrint("🔁 RESEND OTP STATUS => ${response.statusCode}");
    debugPrint("🔁 RESEND OTP RESPONSE => ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar(
        "Success",
        "OTP resent successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      _error(response.body?['message'] ?? "Failed to resend OTP");
    }
  }

  /// ================= NAVIGATION =================
  void _handleNavigation() {
    debugPrint("➡ NAVIGATION PURPOSE => $purpose");

    if (purpose == OtpPurpose.loginOtp.value) {
      Get.offAllNamed(AppRoute.signindone);
    }

    else if (purpose == OtpPurpose.emailVerify.value) {
      Get.offAllNamed(AppRoute.signUpPhone);
    }

    else if (purpose == OtpPurpose.phoneVerify.value) {
      Get.offAllNamed(AppRoute.createaccount);
    }

    /// 🧬 BIOMETRIC ENABLE
    else if (purpose == OtpPurpose.biometricEnable.value) {
      if (biometricType == "face") {
        Get.offAllNamed(AppRoute.verifyFaceId);
      } else {
        Get.offAllNamed(AppRoute.verifyfingerprint);
      }
    }

    else {
      Get.back();
    }
  }

  /// ================= SAVE DATA =================
  Future<void> _saveUserData(dynamic data) async {
    if (data == null) return;

    /// ================= USER BASIC INFO =================
    if (data['email'] != null && data['email'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userEmail,
        data['email'],
      );
    }

    if (data['userId'] != null && data['userId'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userId,
        data['userId'],
      );
    }

    if (data['role'] != null && data['role'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        data['role'],
      );
    }

    /// ================= NORMAL TOKENS =================
    /// (Email verify / Login case)
    if (data['accessToken'] != null &&
        data['accessToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.bearerToken,
        data['accessToken'],
      );
    }

    if (data['refreshToken'] != null &&
        data['refreshToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.refreshToken,
        data['refreshToken'],
      );
    }

    /// ================= BIOMETRIC TOKEN =================
    /// (Biometric enable case)
    if (data['biometricToken'] != null &&
        data['biometricToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.biometricToken,
        data['biometricToken'],
      );
    }
  }


  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

