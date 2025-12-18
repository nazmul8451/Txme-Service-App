import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';

class FingerprintController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final ApiClient apiClient = Get.find<ApiClient>();

  RxBool isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🟢 FingerprintController onInit");
    _startFingerprint();
  }

  /// ================= START BIOMETRIC =================
  Future<void> _startFingerprint() async {
    if (isScanning.value) return;

    try {
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      if (!supported || !canCheck) {
        _error("Biometric not available");
        return;
      }

      isScanning.value = true;

      final authenticated = await auth.authenticate(
        localizedReason: 'Verify using biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      isScanning.value = false;

      if (authenticated) {
        await _biometricLoginApi();
      }
    } catch (e) {
      isScanning.value = false;
      _error(e.toString());
    }
  }

  /// ================= BIOMETRIC LOGIN API =================
  Future<void> _biometricLoginApi() async {
    final refreshToken =
    await SharePrefsHelper.getString("refresh_token");

    if (refreshToken.isEmpty) {
      _error("Refresh token not found");
      return;
    }

    debugPrint("🔐 BIOMETRIC LOGIN REQUEST");

    final response = await apiClient.postData(
      ApiConstant.biometricLogin, // /auth/biometric-login
      {
        "refreshToken": refreshToken,
      },
      needToken: false,
    );

    debugPrint("📡 STATUS => ${response.statusCode}");
    debugPrint("📦 BODY => ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.body['data'];

      /// 🔐 UPDATE ACCESS TOKEN
      await SharePrefsHelper.setString(
        SharePrefsHelper.bearerToken,
        data['accessToken'],
      );

      /// 👤 UPDATE USER INFO
      await SharePrefsHelper.setString(
        SharePrefsHelper.userId,
        data['userInfo']['userId'],
      );

      await SharePrefsHelper.setString(
        SharePrefsHelper.userEmail,
        data['userInfo']['email'],
      );

      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        data['userInfo']['role'],
      );

      debugPrint("✅ BIOMETRIC LOGIN SUCCESS");
      debugPrint("🔁 TOKENS & USER INFO UPDATED");

      Get.offAllNamed(AppRoute.signindone);
    } else {
      _error(response.body?['message'] ?? "Biometric login failed");
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
