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
      print("🟡 STRIPE STATUS: API CALL STARTED");

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final url = ApiConstant.baseUrl + ApiConstant.stripeAccount;
      print("🌐 GET => $url");

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📡 STATUS => ${res.statusCode}");
      print("📨 BODY => ${res.body}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        isStripeConnected.value =
            decoded['data']?['isConnected'] ?? false;

        print("🔗 isStripeConnected => ${isStripeConnected.value}");
      } else {
        isStripeConnected.value = false;
      }
    } catch (e, stack) {
      print("❌ STRIPE STATUS ERROR => $e");
      print(stack);
      isStripeConnected.value = false;
    } finally {
      isStripeLoading(false);
      print("🟢 STRIPE STATUS: FINISHED");
    }
  }

  // ================= CREATE STRIPE SESSION =================

  Future<void> createStripeAccountSession() async {
    try {
      isStripeLoading(true);
      print("🟡 STRIPE SESSION: START");

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final url = ApiConstant.baseUrl + ApiConstant.stripeAccountSession;
      print("🌐 POST => $url");

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📡 STATUS => ${res.statusCode}");
      print("📨 BODY => ${res.body}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final onboardingUrl = decoded['data']?['onboardingUrl'];

        if (onboardingUrl != null && onboardingUrl.isNotEmpty) {
          await startStripeOnboarding(onboardingUrl);
        } else {
          Get.snackbar("Error", "Onboarding URL missing");
        }
      } else {
        Get.snackbar("Error", "Stripe session failed");
      }
    } catch (e) {
      print("❌ STRIPE SESSION ERROR => $e");
    } finally {
      isStripeLoading(false);
    }
  }

  // ================= STRIPE ONBOARDING =================

  Future<void> startStripeOnboarding(String url) async {
    try {
      print("🟢 OPEN STRIPE ONBOARDING");
      print("🌐 $url");

      final uri = Uri.parse(url);

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw "Could not launch Stripe onboarding";
      }

      /// User app এ ফিরে আসলে refresh হবে
      await Future.delayed(const Duration(seconds: 3));
      await fetchStripeAccountStatus();
    } catch (e) {
      print("❌ STRIPE ONBOARDING ERROR => $e");
    }
  }


}
