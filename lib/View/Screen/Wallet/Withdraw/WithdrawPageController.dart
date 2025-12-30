import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class Withdrawpagecontroller extends GetxController {
  final ammountController = TextEditingController();

  var isLoading = false.obs;
  var isSuccess = false.obs;

  Future<void> withdrawMoney() async {
    try {
      isLoading(true);
      isSuccess(false);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      print("================================>>>>>>>>>>>>>>>>>>===========================");
      print(token);

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

      print("STATUS => ${res.statusCode}");
      print("BODY => ${res.body}");

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['success'] == true) {
        isSuccess(true);
        Get.snackbar("Success", data['message'] ?? "Withdraw successful");
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Withdraw failed",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

