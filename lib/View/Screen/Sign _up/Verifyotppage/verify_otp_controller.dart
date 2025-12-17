import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';

class VerifyOtpController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  /// ================= STATE =================
  String email = "";
  String channel = "email";
  String purpose = ""; // dynamic
  String otpCode = "";

  bool isLoading = false;

  /// ================= STORAGE KEYS =================
  static const String userIdKey = "user_id";
  static const String userEmailKey = "user_email";
  static const String refreshTokenKey = "refresh_token";

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
    final userInfo = data['userInfo'];
    final tokens = data['tokens'];

    debugPrint("💾 SAVING USER DATA...");

    /// 🔐 TOKENS
    await SharePrefsHelper.setString(
      SharePrefsHelper.bearerToken,
      tokens['accessToken'],
    );

    await SharePrefsHelper.setString(
      refreshTokenKey,
      tokens['refreshToken'],
    );

    /// 👤 USER INFO
    await SharePrefsHelper.setString(userIdKey, userInfo['userId']);
    await SharePrefsHelper.setString(userEmailKey, userInfo['email']);

    /// 🎭 ROLE (save once)
    await SharePrefsHelper.setString(
      SharePrefsHelper.userRole,
      userInfo['role'],
    );

    /// ✅ CONFIRM PRINT
    debugPrint("✅ USER ID => ${userInfo['userId']}");
    debugPrint("✅ EMAIL => ${userInfo['email']}");
    debugPrint("✅ ROLE => ${userInfo['role']}");
    debugPrint("✅ ACCESS TOKEN SAVED");
    debugPrint("✅ REFRESH TOKEN SAVED");
  }

  /// ================= PURPOSE BASED NAVIGATION =================
  void _handleNavigation() {
    debugPrint("➡ NAVIGATING BASED ON PURPOSE => $purpose");

    if (purpose == "login_otp") {
      debugPrint("🏠 LOGIN OTP VERIFIED → SIGN DONE PAGE");
      Get.offAllNamed(AppRoute.signindone);
    }
    else if (purpose == "email_verify") {
      debugPrint("📱 EMAIL VERIFIED → PHONE NUMBER PAGE");
      Get.offAllNamed(AppRoute.signUpPhone);
    }
    else {
      debugPrint("⚠ UNKNOWN PURPOSE → GO BACK");
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
