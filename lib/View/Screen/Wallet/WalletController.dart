import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WalletController extends GetxController {
  // Selected button index
  var selectedIndex = (-1).obs;

  // Available balance
  var balance = ''.obs;

  // Transactions list
  var transactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  // Simulate fetching data from API
  void fetchWalletData() async {
    // Example API call: replace with your actual API
    await Future.delayed(Duration(seconds: 1));

    // Sample data from API
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
      {
        "type": "Received",
        "amount": "€200.00",
        "note": "Payment from client",
        "timeAgo": "5 days ago"
      },
    ];
  }

  void selectButton(int index) {
    selectedIndex.value = index;
  }
}
