import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class SettingsController extends GetxController {
  // General Toggles
  final generalNotification = true.obs;
  final soundNotification = true.obs;
  final vibrateNotification = true.obs;

  // API-driven Settings
  final profilePromotionEnabled = false.obs;
  final cardPaymentEnabled = false.obs;
  final sendInMessageEnabled = false.obs;
  final paymentByCardEnabled = false.obs;
  final paymentByPaypalEnabled = false.obs;
  final walletFeaturesEnabled = false.obs;

  // Admin-controlled flags
  final profilePromotionAdminControlled = true.obs;
  final cardPaymentAdminControlled = true.obs;
  final sendInMessageAdminControlled = true.obs;
  final paymentByCardAdminControlled = true.obs;
  final paymentByPaypalAdminControlled = true.obs;
  final walletFeaturesAdminControlled = true.obs;

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.setting}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        // Update observables from API data
        profilePromotionEnabled.value = data['profilePromotion']?['enabled'] ?? false;
        profilePromotionAdminControlled.value = data['profilePromotion']?['adminControlled'] ?? true;

        cardPaymentEnabled.value = data['cardPayment']?['enabled'] ?? false;
        cardPaymentAdminControlled.value = data['cardPayment']?['adminControlled'] ?? true;

        sendInMessageEnabled.value = data['sendInMessage']?['enabled'] ?? false;
        sendInMessageAdminControlled.value = data['sendInMessage']?['adminControlled'] ?? true;

        final digitalPayments = data['digitalPayments'];
        paymentByCardEnabled.value = digitalPayments?['paymentByCard']?['enabled'] ?? false;
        paymentByCardAdminControlled.value = digitalPayments?['paymentByCard']?['adminControlled'] ?? true;

        paymentByPaypalEnabled.value = digitalPayments?['paymentByPaypal']?['enabled'] ?? false;
        paymentByPaypalAdminControlled.value = digitalPayments?['paymentByPaypal']?['adminControlled'] ?? true;

        walletFeaturesEnabled.value = digitalPayments?['paymentByWallet']?['enabled'] ?? false;
        walletFeaturesAdminControlled.value = digitalPayments?['paymentByWallet']?['adminControlled'] ?? true;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load settings.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSettings() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final body = jsonEncode({
        "profilePromotion": {"enabled": profilePromotionEnabled.value},
        "cardPayment": {"enabled": cardPaymentEnabled.value},
        "sendInMessage": {"enabled": sendInMessageEnabled.value},
        "digitalPayments": {
          "paymentByCard": {"enabled": paymentByCardEnabled.value},
          "paymentByPaypal": {"enabled": paymentByPaypalEnabled.value},
          "paymentByWallet": {"enabled": walletFeaturesEnabled.value},
        }
      });

      final response = await http.patch(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.setting}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Settings saved successfully!");
      } else {
        Get.snackbar("Error", "Failed to save settings.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle methods
  void toggleProfilePromotion() => profilePromotionEnabled.toggle();
  void toggleCardPayment() => cardPaymentEnabled.toggle();
  void toggleSendInMessage() => sendInMessageEnabled.toggle();
  void togglePaymentByCard() => paymentByCardEnabled.toggle();
  void togglePaymentByPaypal() => paymentByPaypalEnabled.toggle();
  void toggleWalletFeatures() => walletFeaturesEnabled.toggle();
}
