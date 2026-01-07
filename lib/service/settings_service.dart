import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';

class SettingsService extends GetxService {
  // Observables for each feature
  final topUpEnabled = true.obs;
  final withdrawEnabled = true.obs;
  final moneyRequestEnabled = true.obs;
  final moneySendEnabled = true.obs;
  final cardPaymentEnabled = true.obs;
  final paypalPaymentEnabled = true.obs;
  final walletPaymentEnabled = true.obs;
  final profilePromotionEnabled = true.obs;
  final sendInMessageEnabled = true.obs;
  final digitalPaymentsEnabled = true.obs; // ✅ ADDED

  Future<void> fetchSettings() async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (token.isEmpty) return;

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.setting}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];

        profilePromotionEnabled.value = data['profilePromotion']?['enabled'] ?? false;
        sendInMessageEnabled.value = data['sendInMessage']?['enabled'] ?? false;

        final walletFeatures = data['digitalPayments']?['paymentByWallet']?['walletFeatures'];
        if (walletFeatures != null) {
          topUpEnabled.value = walletFeatures['topUp']?['enabled'] ?? false;
          withdrawEnabled.value = walletFeatures['withdraw']?['enabled'] ?? false;
          moneyRequestEnabled.value = walletFeatures['moneyRequest']?['enabled'] ?? false;
          moneySendEnabled.value = walletFeatures['moneySend']?['enabled'] ?? false;
        }

        final digitalPayments = data['digitalPayments'];
        if (digitalPayments != null) {
          digitalPaymentsEnabled.value = digitalPayments['enabled'] ?? false; // ✅ ADDED
          cardPaymentEnabled.value = digitalPayments['paymentByCard']?['enabled'] ?? false;
          paypalPaymentEnabled.value = digitalPayments['paymentByPaypal']?['enabled'] ?? false;
          walletPaymentEnabled.value = digitalPayments['paymentByWallet']?['enabled'] ?? false;
        }
        print("✅ Settings loaded successfully");
      }
    } catch (e) {
      print("❌ Failed to load app settings: $e");
    }
  }
}
