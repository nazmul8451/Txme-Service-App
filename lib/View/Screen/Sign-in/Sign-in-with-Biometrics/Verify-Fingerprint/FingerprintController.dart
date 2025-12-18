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
  void onReady() {
    super.onReady();
    _startFingerprint(); // ✅ SAFE HERE
  }

  /// ================= START BIOMETRIC =================
  Future<void> _startFingerprint() async {
    if (isScanning.value) return;

    try {
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;

      if (!supported || !canCheck) {
        _error("Biometric not available on this device");
        return;
      }

      isScanning.value = true;

      final authenticated = await auth.authenticate(
        localizedReason: 'Verify using fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      isScanning.value = false;

      if (authenticated) {
        await _biometricLoginApi();
      } else {
        _error("Fingerprint not matched");
      }
    } catch (e) {
      isScanning.value = false;
      debugPrint("❌ BIOMETRIC ERROR => $e");
      _error("Biometric authentication failed");
    }
  }

  /// ================= BIOMETRIC LOGIN API =================
  Future<void> _biometricLoginApi() async {
    final biometricToken =
    await SharePrefsHelper.getString(SharePrefsHelper.biometricToken);

    if (biometricToken.isEmpty) {
      _error("Biometric not enabled. Please login first.");
      Get.offAllNamed(AppRoute.signinwithbiometrics);
      return;
    }

    final response = await apiClient.postData(
      ApiConstant.biometricLogin,
      {
        "biometricToken": biometricToken,
      },
      needToken: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.body['data'];

      /// ✅ SAVE ACCESS TOKEN (correct path)
      await SharePrefsHelper.setString(
        SharePrefsHelper.bearerToken,
        data['accessToken'],
      );

      /// 👤 USER INFO
      final user = data['userInfo'];

      await SharePrefsHelper.setString(
        SharePrefsHelper.userId,
        user['userId'],
      );

      await SharePrefsHelper.setString(
        SharePrefsHelper.userEmail,
        user['email'],
      );

      await SharePrefsHelper.setString(
        SharePrefsHelper.userRole,
        user['role'],
      );

      debugPrint("✅ BIOMETRIC LOGIN SUCCESS");

      /// 🚀 GO TO HOME
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

