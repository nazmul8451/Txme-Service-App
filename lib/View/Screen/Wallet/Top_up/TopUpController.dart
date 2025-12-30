import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/App_Routes/app_routes.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class Topupcontroller extends GetxController {
  final ammountController = TextEditingController();
  final messageController = TextEditingController();

  final selectedPaymentIndex = 2.obs; // Stripe
  final isLoading = false.obs;

  /// 🔥 CREATE PAYMENT INTENT
  Future<void> createPaymentIntent() async {
    if (isLoading.value) return;

    final rawAmount = ammountController.text.trim();
    debugPrint("🟡 Raw amount: $rawAmount");

    if (rawAmount.isEmpty) {
      Get.snackbar("Error", "Amount required");
      return;
    }

    final amount = int.tryParse(rawAmount);
    debugPrint("🟡 Parsed amount: $amount");

    if (amount == null || amount <= 0) {
      Get.snackbar("Error", "Invalid amount");
      return;
    }

    final token = await SharePrefsHelper.getString(
      SharePrefsHelper.bearerToken,
    );

    debugPrint("🟢 Token: $token");

    if (token.isEmpty) {
      Get.snackbar("Error", "Invalid token");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.createPaymentIntent),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount, // ⚠️ dollars/euro only (backend → *100)
          "currency": "eur",
        }),
      );

      debugPrint("🟢 Status: ${response.statusCode}");
      debugPrint("🟢 Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final clientSecret = data["data"]["clientSecret"];

        debugPrint("===================================>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<======================$clientSecret");

        await makeStripePayment(
          clientSecret: clientSecret,
          amount: amount,
        );
      } else {
        Get.snackbar("Error", data["message"] ?? "Payment failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ///  STRIPE PAYMENT

  Future<void> makeStripePayment({
    required String clientSecret,
    required int amount,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "TXME",

        ),
      );

      await Stripe.instance.presentPaymentSheet();


      ///  Payment success
      Get.snackbar(
        "Success",
        "€$amount Payment Successful",
        snackPosition: SnackPosition.TOP,
      );

      /// 👉 Done page + amount pass
      Get.offAllNamed(
        AppRoute.walletpage,
        arguments: {
          "amount": amount,
          "currency": "EUR",
        },
      );

    }

    ///  Stripe failed / cancelled
    on StripeException catch (e) {
      debugPrint("❌ Stripe Error: ${e.error.message}");

      Get.offAllNamed(
        AppRoute.transactionfailed,
        arguments: {
          "message": e.error.message ?? "Payment cancelled",
          "amount": amount,
        },
      );
    }

    ///  Any other error
    catch (e) {
      debugPrint("❌ Unknown Error: $e");

      Get.offAllNamed(
        AppRoute.transactionfailed,
        arguments: {
          "message": "Something went wrong",
          "amount": amount,
        },
      );
    }
  }


  @override
  void onClose() {
    ammountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
