import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Model/UserModel.dart';
import '../../User Role/Home_Page/models/provider_stats_model.dart';



class UserHeaderController extends GetxController {
  final isLoading = false.obs;
  final user = Rxn<UserModel>();
  final providerStats = Rx<ProviderStats?>(null);

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
    fetchStripeAccountStatus();
    fetchProviderStats(); // ✅ ADDED
  }

  Future<void> fetchUserHeader() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

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
        Get.snackbar("Failed to load profile", "");
      }
    } catch (e) {
      Get.snackbar(e.toString(), "");
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
      isStripeLoading(false);
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



  Future<void> fetchProviderStats() async {
    try {
      final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);
      final id = await SharePrefsHelper.getString(SharePrefsHelper.userId);

      if (id == null || id.isEmpty) return; //  Guard clause

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.providerStats}$id/statistics"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          providerStats.value = ProviderStats.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      print("Error fetching provider stats: $e");
    }
  }
}
