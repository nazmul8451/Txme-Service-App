import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../otp_purpose.dart';

class VerifyOtpController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  /// ================= STATE =================
  String email = "";
  String channel = "email";
  String purpose = ""; // dynamic
  String otpCode = "";

  bool isLoading = false;


  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    email = args['email'] ?? "";
    purpose = args['purpose'] ?? "email_verify"; // fallback only

    debugPrint("📥 OTP PAGE ARGS => $args");
    debugPrint("📧 EMAIL => $email");
    debugPrint("🎯 PURPOSE => $purpose");
  }

  /// ================= OTP INPUT =================
  void onOtpChanged(String value) {
    otpCode = value;
    debugPrint("⌨️ OTP INPUT => $otpCode");
  }

  /// ================= VERIFY OTP =================
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

    debugPrint("🚀 VERIFY OTP REQUEST => $body");

    final response = await apiClient.postData(
      ApiConstant.signUpEmailVerifyOtp,
      body,
      needToken: false,
    );

    isLoading = false;
    update();

    debugPrint("📡 STATUS CODE => ${response.statusCode}");
    debugPrint("📦 RESPONSE BODY => ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      await _saveUserData(response.body['data']);
      _handleNavigation(); //  purpose based redirect
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

  /// ================= SAVE USER DATA =================
  Future<void> _saveUserData(dynamic data) async {
    debugPrint("💾 SAVING USER DATA => $data");

    /// ================= EMAIL (SAFE) =================
    String? finalEmail =
        data['email'] ??
            data['userInfo']?['email'];

    if (finalEmail != null && finalEmail.isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userEmail,
        finalEmail,
      );
      debugPrint("📧 EMAIL SAVED => $finalEmail");
    }

    /// ================= USER ID =================
    String? finalUserId =
        data['userId'] ??
            data['userInfo']?['userId'];

    if (finalUserId != null && finalUserId.isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userId,
        finalUserId,
      );
      debugPrint("👤 USER ID SAVED => $finalUserId");
    }

    /// ================= ROLE =================
    String? finalRole =
        data['role'] ??
            data['userInfo']?['role'];

    if (finalRole != null && finalRole.isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        finalRole,
      );
      debugPrint("🎭 ROLE SAVED => $finalRole");
    }

    /// ================= BIOMETRIC TOKEN =================
    if (data['biometricToken'] != null &&
        data['biometricToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.biometricToken,
        data['biometricToken'],
      );
      debugPrint("🧬 BIOMETRIC TOKEN SAVED");
    }

    /// ================= NORMAL LOGIN TOKENS =================
    if (data['tokens'] != null) {
      final tokens = data['tokens'];

      if (tokens['accessToken'] != null) {
        await SharePrefsHelper.setString(
          SharePrefsHelper.bearerToken,
          tokens['accessToken'],
        );
        debugPrint("🔐 ACCESS TOKEN SAVED");
      }

      if (tokens['refreshToken'] != null) {
        await SharePrefsHelper.setString(
          SharePrefsHelper.refreshToken,
          tokens['refreshToken'],
        );
        debugPrint("🔁 REFRESH TOKEN SAVED");
      }
    }
  }






  /// ================= PURPOSE BASED NAVIGATION =================
  void _handleNavigation() {
    debugPrint("➡ NAVIGATING BASED ON PURPOSE => $purpose");

    if (purpose == OtpPurpose.loginOtp.value) {
      Get.offAllNamed(AppRoute.signindone);

    } else if (purpose == OtpPurpose.emailVerify.value) {
      Get.offAllNamed(AppRoute.signUpPhone);

    } else if (purpose == OtpPurpose.phoneVerify.value) {
      Get.offAllNamed(AppRoute.createaccount);

    }
    /// 🧬 BIOMETRIC ENABLE SUCCESS
    else if (purpose == OtpPurpose.biometricEnable.value) {
      debugPrint("🧬 BIOMETRIC ENABLED → FINGERPRINT PAGE");
      Get.offAllNamed(AppRoute.verifyfingerprint);
    }
    else {
      Get.back();
    }
  }



  /// ================= ERROR =================
  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}
