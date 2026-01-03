import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../service/api_url.dart';
import 'modelTransactions.dart';

class WalletController extends GetxController {
  var selectedIndex = (-1).obs;

  final isLoading = false.obs;

  /// 🔥 Recent Transactions (Model list)
  final transactions = <WalletTransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

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
      isLoading(false);
    }
  }

  Future<void> refreshWallet() async {
    await fetchWalletData();
  }

  void selectButton(int index) {
    selectedIndex.value = index;
  }
}


