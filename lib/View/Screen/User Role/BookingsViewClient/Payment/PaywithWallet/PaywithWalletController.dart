import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/App_Routes/app_routes.dart';
import '../../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../../service/api_url.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';

class PayWithWalletController extends GetxController {
  final isLoading = false.obs;

  /// Note field
  final TextEditingController noteController = TextEditingController();

  /// ================= PAY WITH WALLET =================
  Future<void> payWithWallet(AppointmentModel2 appointment) async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}"
            "${ApiConstant.walletPay}"
            "${appointment.id}",
      );

      final body = {
        "note": noteController.text.trim(),
      };

      debugPrint("🟡 WALLET PAY URL => $uri");
      debugPrint("🟡 WALLET PAY BODY => $body");

      final res = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("📡 STATUS => ${res.statusCode}");
      debugPrint("📨 BODY => ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.offAllNamed(AppRoute.providerpaymentsuccessful, arguments: appointment);
        Get.snackbar("Success", "Payment completed successfully");
      } else {
        Get.snackbar("Error", "Payment failed");
      }
    } catch (e) {
      debugPrint("❌ WALLET PAY ERROR => $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
