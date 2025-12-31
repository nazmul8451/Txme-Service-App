import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WalletController extends GetxController {
  var selectedIndex = (-1).obs;

  var balance = ''.obs;
  var transactions = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  /// 🔄 MAIN API CALL
  Future<void> fetchWalletData() async {
    try {
      isLoading.value = true;

      /// TODO: Replace with real API
      await Future.delayed(const Duration(seconds: 1));

      balance.value = "€2,450.00";

      transactions.value = [
        {
          "type": "Received",
          "amount": "€150.00",
          "note": "Payment from client",
          "timeAgo": "2 days ago"
        },
        {
          "type": "Sent",
          "amount": "€50.00",
          "note": "Payment to vendor",
          "timeAgo": "3 days ago"
        },
      ];
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 Pull-to-refresh
  Future<void> refreshWallet() async {
    await fetchWalletData();
  }

  void selectButton(int index) {
    selectedIndex.value = index;
  }
}

