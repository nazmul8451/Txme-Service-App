import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../helper/Shared_prefe/shared_prefe.dart';


class Paywithcashcontroller extends GetxController {
  // API থেকে আসবে data
  var recipientName = "".obs;
  var accountNumber = "".obs;
  var routingNumber = "".obs;
  var amount = "".obs;

  // ✅ User ID for socket connection
  var userId = "".obs;

  // User input
  TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
    fetchPaymentData();
  }

  // ✅ Load User ID from SharedPreferences
  Future<void> _loadUserId() async {
    try {
      final id = await SharePrefsHelper.getString(SharePrefsHelper.userId);
      userId.value = id ?? '';
      debugPrint("👤 PayWithCash User ID: ${userId.value}");
    } catch (e) {
      debugPrint("❌ Error loading user ID: $e");
    }
  }

  // API থেকে data fetch
  void fetchPaymentData() {
    // এখানে তোমার API call হবে, এখন sample data দেওয়া হলো
    recipientName.value = "Michelle R.";
    accountNumber.value = "4000 1234 5678 9010";
    routingNumber.value = "€87.00";
    amount.value = "€87.00";
  }

  // Submit function
  void submitPayment() {
    // এখানে তুমি API call করে payment করতে পারো
    debugPrint("Recipient Name: ${recipientName.value}");
    debugPrint("Account Number: ${accountNumber.value}");
    debugPrint("Routing Number: ${routingNumber.value}");
    debugPrint("Amount: ${amount.value}");
    debugPrint("Note: ${noteController.text}");
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}