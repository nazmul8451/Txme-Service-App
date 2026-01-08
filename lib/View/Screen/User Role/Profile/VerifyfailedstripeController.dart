import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class Verifyfailedstripecontroller extends GetxController{

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    createStripeAccountSession();
  }



  // ================= CREATE SESSION =================
  Future<void> createStripeAccountSession() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.post(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.stripeAccountSession),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({}), // 🔥 EMPTY BODY (IMPORTANT)
      );

      if (res.statusCode != 200) {
        Get.snackbar("Stripe link create failed", "");
        return;
      }

      final data = jsonDecode(res.body)['data'];
      final String? url = data?['url'];

      if (url == null) {
        Get.snackbar("Stripe URL missing", "");
        return;
      }

      await _openStripeLink(url);

    } catch (e) {
      print("❌ Stripe Error => $e");
      Get.snackbar("Stripe onboarding failed", "");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _openStripeLink(String url) async {
    try {
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        Get.snackbar("Cannot open browser", "");
        return;
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar("Stripe open failed", "");
      print("Launch error => $e");
    }
  }


}