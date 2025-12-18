import 'package:get/get.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';


class BiometricsController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  RxBool isLoading = false.obs;

  /// 🔐 Fingerprint button main handler
  Future<void> onFingerprintClick() async {
    final biometricToken =
    await SharePrefsHelper.getString(SharePrefsHelper.biometricToken);

    if (biometricToken.isNotEmpty) {
      /// biometric token আছে → local fingerprint page
      Get.toNamed(AppRoute.verifyfingerprint);
    } else {
      /// biometric token নাই → enable biometric (OTP flow)
      await _sendBiometricOtp();
    }
  }

  /// 🔐 SEND OTP TO EMAIL (enable-biometric)
  Future<void> _sendBiometricOtp() async {
    final email =
    await SharePrefsHelper.getString(SharePrefsHelper.userEmail);

    if (email.isEmpty) {
      Get.snackbar("Error", "Email not found, please login with Gmail first");
      return;
    }

    isLoading.value = true;

    final response = await apiClient.postData(
      ApiConstant.enableBiometric,
      {
        "email": email,
      },
      needToken: false, //  access token লাগবে না
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      /// OTP page
      Get.toNamed(
        AppRoute.verifyotppageS,
        arguments: {
          "purpose": "enable_biometric",
          "email": email,
        },
      );
    } else {
      Get.snackbar(
        "Error",
        response.body?['message'] ?? "Failed to send OTP",
      );
    }
  }
}

