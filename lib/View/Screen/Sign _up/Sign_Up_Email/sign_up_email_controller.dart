import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../otp_purpose.dart';

class SignUpEmailController extends GetxController {
  final emailController = TextEditingController();
  final ApiClient apiClient = Get.find<ApiClient>();

  bool isChecked = false;
  bool isLoading = false;

  String role = ""; //  role এখানে থাকবে

  @override
  void onInit() {
    super.onInit();
    _loadRole();
  }

  ///  SharedPreferences থেকে role load
  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString("user_role") ?? "";

    ///  PRINT ROLE
    debugPrint("SIGN UP ROLE => $role");
  }

  /// Gmail validation
  bool _isValidGmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+');
    return regex.hasMatch(email);
  }

  /// checkbox change
  void onCheckChanged(bool value) {
    isChecked = value;
    update();
  }

  /// Verify Email button click
  Future<void> onVerifyEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _error("Email is required");
      return;
    }

    if (!_isValidGmail(email)) {
      _error("Only Gmail address allowed");
      return;
    }

    if (!isChecked) {
      _error("Please accept Terms & Conditions");
      return;
    }

    ///  PRINT REQUEST DATA
    debugPrint("EMAIL => $email");
    debugPrint("ROLE  => $role");

    /// ================= API CALL =================
    isLoading = true;
    update();

    final response = await apiClient.postData(
      ApiConstant.signUpSendEmailOtp,
      {
        "email": email,
        "role": role, // PROVIDER / USER
      },
      needToken: false, //  IMPORTANT
    );


    isLoading = false;
    update();

    ///  PRINT RESPONSE
    debugPrint("STATUS CODE => ${response.statusCode}");
    debugPrint("RESPONSE BODY => ${response.body}");

    /// ================= RESPONSE CHECK =================
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(AppRoute.verifyotppageS,    arguments: {
        "email": email,
        'channel': OtpChannel.email.value,
        "purpose": OtpPurpose.emailVerify.value,
      },

      );
    } else {
      _error(
        response.body?['message'] ?? "Something went wrong",
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
