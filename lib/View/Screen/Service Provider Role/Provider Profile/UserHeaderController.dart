import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Model/UserModel.dart';



class UserHeaderController extends GetxController {
  final isLoading = false.obs;
  final user = Rxn<UserModel>();


  /// Stripe states
  final isStripeConnected = false.obs; // ✅ default false
  final isStripeLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserHeader();
    fetchStripeAccountStatus();
  }

  Future<void> fetchUserHeader() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      print("========================>..............=====================");
      print(token);
      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        user.value = UserModel.fromJson(decoded['data']);
      } else {
        Get.snackbar("Error", "Failed to load profile");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }


  // ================= STRIPE STATUS =================

  Future<void> fetchStripeAccountStatus() async {
    try {
      isStripeLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.stripeAccount),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        isStripeConnected.value =
            jsonDecode(res.body)['data']?['isConnected'] ?? false;
      } else {
        isStripeConnected.value = false;
      }
    } finally {
      isStripeLoading(false);
    }
  }

  // ================= CREATE SESSION =================

  Future<void> createStripeAccountSession() async {
    try {
      isStripeLoading(true);

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

      print("STATUS => ${res.statusCode}");
      print("BODY => ${res.body}");

      if (res.statusCode != 200) {
        Get.snackbar("Error", "Stripe link create failed");
        return;
      }

      final data = jsonDecode(res.body)['data'];
      final String? url = data?['url'];

      if (url == null) {
        Get.snackbar("Error", "Stripe URL missing");
        return;
      }

      await _openStripeLink(url);

    } catch (e) {
      print("❌ Stripe Error => $e");
      Get.snackbar("Error", "Stripe onboarding failed");
    } finally {
      isStripeLoading(false);
    }
  }





  Future<void> _openStripeLink(String url) async {
    try {
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        Get.snackbar("Error", "Cannot open browser");
        return;
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar("Error", "Stripe open failed");
      print("Launch error => $e");
    }
  }


}
