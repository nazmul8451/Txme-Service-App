import 'package:get/get.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';


class BiometricsController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  RxBool isLoading = false.obs;

  /// 🔐 ENABLE BIOMETRIC API
  Future<void> enableBiometric() async {
    final accessToken =
    await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (accessToken.isEmpty) {
      Get.snackbar("Error", "Access token not found");
      return;
    }

    isLoading.value = true;

    final response = await apiClient.postData(
      ApiConstant.enableBiometric, // /auth/enable-biometric
      {},
      needToken: true, // Authorization header যাবে
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ///  biometric enabled → go to scan page
      Get.toNamed(AppRoute.verifyfingerprint);
    } else {
      Get.snackbar(
        "Error",
        response.body?['message'] ?? "Failed to enable biometric",
      );
    }
  }
}
