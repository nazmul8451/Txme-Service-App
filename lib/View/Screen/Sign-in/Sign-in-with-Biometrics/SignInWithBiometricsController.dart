import 'package:get/get.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';


class BiometricsController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  /// ================= FINGER =================
  Future<void> onFingerprintClick() async {
    final token =
    await SharePrefsHelper.getString(SharePrefsHelper.biometricToken);

    if (token.isNotEmpty) {
      Get.toNamed(AppRoute.verifyfingerprint);
    } else {
      await _sendBiometricOtp(purpose: "biometric_enable");
    }
  }

  /// ================= FACE =================
  Future<void> onFaceIdClick() async {
    final token =
    await SharePrefsHelper.getString(SharePrefsHelper.biometricToken);

    if (token.isNotEmpty) {
      Get.toNamed(AppRoute.verifyFaceId);
    } else {
      await _sendBiometricOtp(purpose: "biometric_enable");
    }
  }

  /// ================= SEND OTP =================
  Future<void> _sendBiometricOtp({required String purpose}) async {
    final email =
    await SharePrefsHelper.getString(SharePrefsHelper.userEmail);

    if (email.isEmpty) {
      Get.snackbar("Error", "Email not found");
      return;
    }

    final response = await apiClient.postData(
      ApiConstant.enableBiometric,
      {
        "email": email,
        "purpose": purpose,
      },
      needToken: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(
        AppRoute.verifyotppageS,
        arguments: {
          "purpose": purpose,
          "email": email,
        },
      );
    } else {
      Get.snackbar("Error", "Failed to send OTP");
    }
  }
}




