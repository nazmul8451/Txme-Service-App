import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../WalletTransaction.dart';

class Withdrawpagecontroller extends GetxController {
  final ammountController = TextEditingController();

  var isLoading = false.obs;
  var isSuccess = false.obs;

  /// ✅ Withdraw API
  Future<WalletTransaction?> withdrawMoney() async {
    try {
      isLoading(true);
      isSuccess(false);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.post(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.walletWithdraw),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": int.parse(ammountController.text.trim()),
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {

        /// ✅ transaction parse
        final transaction =
        WalletTransaction.fromJson(data['data']);

        isSuccess(true);

        Get.snackbar("Success", data['message'] ?? "Withdraw successful");

        /// ✅ return transaction
        return transaction;
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Withdraw failed",
        );
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }
}

