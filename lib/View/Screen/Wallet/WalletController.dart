import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';
import 'modelTransactions.dart';

class WalletController extends GetxController {
  var isLoading = true.obs;
  var transactions = <WalletTransactionModel>[].obs;
  var selectedIndex = 0.obs; // ✅ ADDED

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  // ✅ ADDED
  void selectButton(int index) {
    selectedIndex.value = index;
  }

  // ✅ ADDED
  Future<void> refreshWallet() async {
    await fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (token.isEmpty) return;

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.myTransactions),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List list = decoded['data']?['result'] ?? [];

        /// 🔥 first 5 only
        transactions.value = list
            .take(5)
            .map((e) => WalletTransactionModel.fromJson(e))
            .toList();
      } else {
        transactions.clear();
      }
    } catch (e) {
      print("Wallet error => $e");
      transactions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String format24h(String isoString) {
    if (isoString.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return "";
    }
  }
}
