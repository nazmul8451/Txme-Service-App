import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../otp_purpose.dart';

class VerifyOtpController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  String identifier = ""; // ✅ UPDATED: To hold either email or phone
  String channel = "";
  String purpose = "";
  String biometricType = "";
  String otpCode = "";

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    
    // ✅ UPDATED: Set identifier dynamically
    identifier = args['email'] ?? args['phone'] ?? "";
    purpose = args['purpose'] ?? "";
    channel = args['channel'] ?? "email";
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
      "identifier": identifier, // ✅ UPDATED
      "oneTimeCode": otpCode,
    };
    
    debugPrint("✅ Verifying OTP with body: $body");

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

  Future<void> resendOtp() async {
    if (identifier.isEmpty) {
      _error("Identifier not found");
      return;
    }

    isLoading = true;
    update();

    final body = {
      "identifier": identifier, // ✅ UPDATED
      "channel": channel,
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

  Future<void> startKycProcess() async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.kycSession}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body)['data'];
        final String? url = data?['url'];

        if (url != null && await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          _error("Could not launch KYC page.");
        }
      } else {
        _error("Could not start KYC process.");
      }
    } catch (e) {
      _error("An error occurred during KYC.");
    }
  }

  void _handleNavigation() {
    debugPrint("➡ NAVIGATION PURPOSE => $purpose");

    if (purpose == OtpPurpose.loginOtp.value) {
      Get.offAllNamed(AppRoute.signindone);
    } else if (purpose == OtpPurpose.emailVerify.value) {
      // startKycProcess();
      Get.offAllNamed(AppRoute.signUpPhone);
    } else if (purpose == OtpPurpose.phoneVerify.value) {
      startKycProcess();
    } else if (purpose == OtpPurpose.biometricEnable.value) {
      if (biometricType == "face") {
        Get.offAllNamed(AppRoute.verifyFaceId);
      } else {
        Get.offAllNamed(AppRoute.verifyfingerprint);
      }
    } else {
      Get.back();
    }
  }

  Future<void> _saveUserData(dynamic data) async {
    if (data == null) return;

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

    if (data['accessToken'] != null && data['accessToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.bearerToken,
        data['accessToken'],
      );
      print(data['accessToken']);
    }

    if (data['refreshToken'] != null && data['refreshToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.refreshToken,
        data['refreshToken'],
      );
    }

    if (data['biometricToken'] != null && data['biometricToken'].toString().isNotEmpty) {
      await SharePrefsHelper.setString(
        SharePrefsHelper.biometricToken,
        data['biometricToken'],
      );
    }
  }

  void _error(String msg) {
    Get.snackbar(
      "Please enter correct OTP",
      msg,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
