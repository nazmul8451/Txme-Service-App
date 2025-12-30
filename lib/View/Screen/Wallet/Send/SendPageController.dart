import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class Sendpagecontroller extends GetxController {
  // TextField controllers
  final ammountController = TextEditingController();
  final nameController = TextEditingController();
  final messageController = TextEditingController();

  // Selected payment method index
  var selectedPaymentIndex = 1.obs;


  // Loading state
  final isSending = false.obs;

  /// ================= SEND WALLET MONEY =================
  Future<void> sendMoney() async {
    try {
      isSending(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      if (token == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      final receiver = nameController.text.trim();
      final amountText = ammountController.text.trim();

      if (receiver.isEmpty || amountText.isEmpty) {
        Get.snackbar("Error", "Receiver & amount required");
        return;
      }

      final amount = double.tryParse(amountText);
      if (amount == null || amount <= 0) {
        Get.snackbar("Error", "Invalid amount");
        return;
      }

      final res = await http.post(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.walletSend),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "receiverIdOrEmail": receiver,
          "amount": amount,
        }),
      );

      print("STATUS => ${res.statusCode}");
      print("BODY => ${res.body}");

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200 && decoded['success'] == true) {
        Get.snackbar("Success", "Money sent successfully ✅");

        // Clear inputs
        ammountController.clear();
        nameController.clear();
        messageController.clear();

        // Optionally refresh balance
      } else {
        Get.snackbar(
          "Error",
          decoded['message'] ?? "Transaction failed",
        );
      }
    } catch (e) {
      print("❌ Wallet Send Error => $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSending(false);
    }
  }

  /// ================= FETCH BALANCE (Dummy for now) =================

  @override
  void onInit() {
    super.onInit();
    sendMoney();
  }

  @override
  void onClose() {
    ammountController.dispose();
    nameController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
