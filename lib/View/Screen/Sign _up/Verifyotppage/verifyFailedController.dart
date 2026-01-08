import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';


class Verifyfailedcontroller extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  var isLoading = false.obs;

  Future<void> startKycProcess() async {
    try {
      isLoading.value = true;
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
          Get.snackbar("", "KYC URL not found");
        }
      } else {
        Get.snackbar("", "Failed to start KYC process");
      }
    } catch (e) {
      Get.snackbar("", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
