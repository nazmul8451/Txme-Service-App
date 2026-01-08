import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Model/UserModel.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  final isStripeLoading = false.obs;

  //  Stripe raw states
  final isConnected = false.obs;
  final detailsSubmitted = false.obs;
  final payoutsEnabled = false.obs;
  final chargesEnabled = false.obs;

  //  FINAL STATE (button hide / show)
  bool get isStripeFullyVerified =>
      isConnected.value &&
          detailsSubmitted.value &&
          payoutsEnabled.value &&
          chargesEnabled.value;

  @override
  void onInit() {
    super.onInit();
    fetchUserHeader();
    update();
    fetchStripeAccountStatus();
  }

  // ================= USER =================

  Future<void> fetchUserHeader() async {
    update();
    try {
      isLoading(true);
      final token =
          await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      print(token);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        user.value = UserModel.fromJson(jsonDecode(res.body)['data']);
      }
      update();
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
        final data = jsonDecode(res.body)['data'];

        isConnected.value = data?['isConnected'] ?? false;
        detailsSubmitted.value = data?['detailsSubmitted'] ?? false;
        payoutsEnabled.value = data?['payoutsEnabled'] ?? false;
        chargesEnabled.value = data?['chargesEnabled'] ?? false;
      } else {
        isConnected(false);
        detailsSubmitted(false);
        payoutsEnabled(false);
        chargesEnabled(false);
      }
    } finally {
      isStripeLoading(false);
    }
  }

  // ================= CREATE SESSION =================

  Future<void> createStripeAccountSession() async {
    update();
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
      update();
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
