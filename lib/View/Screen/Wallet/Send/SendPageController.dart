import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../WalletTransaction.dart';

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
  Future<WalletTransaction?> sendMoney() async {
    try {
      isSending(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      print("Bearer Token =======================>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<=========================== $token");

      if (token == null) {
        Get.snackbar("", "User not authenticated");
        return null;
      }

      final receiver = nameController.text.trim();
      final amountText = ammountController.text.trim();

      if (receiver.isEmpty || amountText.isEmpty) {
        return null;
      }

      final amount = double.tryParse(amountText);
      if (amount == null || amount <= 0) {
        Get.snackbar("", "Invalid amount");
        return null;
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
          "amount": amount
        }),
      );

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200 && decoded['success'] == true) {
        final transaction =
        WalletTransaction.fromJson(decoded['data']);

        ammountController.clear();
        nameController.clear();

        return transaction; //  SUCCESS DATA
      } else {
        Get.snackbar("Error", decoded['message'] ?? "Transaction failed");
        return null;
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "Something went wrong");
      return null;
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
    super.onClose();
  }
}
