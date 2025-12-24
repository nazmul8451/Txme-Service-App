import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class WalletControllerA extends GetxController {
  final isLoading = false.obs;
  final balance = "0.00".obs;

  /// 🔄 GET AVAILABLE BALANCE
  Future<void> getAvailableBalance() async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(
        SharePrefsHelper.bearerToken,
      );

      print("🟡 Wallet token: $token");

      if (token.isEmpty) {
        balance.value = "0.00";
        return;
      }

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}${ApiConstant.myWalletAvailableBalance}",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("🟢 Wallet status: ${response.statusCode}");
      print("🟢 Wallet body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        balance.value =
            decoded["data"]["balance"].toString();
      } else {
        balance.value = "0.00";
      }
    } catch (e) {
      print("🔴 Wallet error: $e");
      balance.value = "0.00";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAvailableBalance(); // 🔥 first load
  }
}
