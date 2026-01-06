import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';

class VerifyFaceController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void onInit() {
    super.onInit();
    _verifyFace();
  }

  Future<void> _verifyFace() async {
    final biometricToken =
    await SharePrefsHelper.getString(SharePrefsHelper.biometricToken);

    /// 🔴 Token না থাকলে OTP / biometric page এ ফেরত
    if (biometricToken.isEmpty) {
      Get.offAllNamed(AppRoute.signinwithbiometrics);
      return;
    }

    try {
      /// 🔍 Device support check
      final canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        Get.snackbar("Error", "Face ID not supported on this device");
        Get.offAllNamed(AppRoute.signinwithbiometrics);
        return;
      }

      /// ✅ SYSTEM FACE VERIFY
      final isAuthenticated = await auth.authenticate(
        localizedReason: "Verify your Face ID",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!isAuthenticated) {
        Get.snackbar("Cancelled", "Face verification cancelled");
        return;
      }

      /// 🔐 BIOMETRIC LOGIN API
      final response = await apiClient.postData(
        ApiConstant.biometricLogin,
        {"biometricToken": biometricToken},
        needToken: false,
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];

        await SharePrefsHelper.setString(
          SharePrefsHelper.bearerToken,
          data['accessToken'],
        );

        final user = data['userInfo'];
        await SharePrefsHelper.setString(
            SharePrefsHelper.userId, user['userId']);
        await SharePrefsHelper.setString(
            SharePrefsHelper.userEmail, user['email']);
        await SharePrefsHelper.setString(
            SharePrefsHelper.userRole, user['role']);

        Get.offAllNamed(AppRoute.signindone);
      } else {
        Get.snackbar("", "Face login failed");
      }
    } catch (e) {
      Get.snackbar("", "Face authentication failed");
    }
  }
}
