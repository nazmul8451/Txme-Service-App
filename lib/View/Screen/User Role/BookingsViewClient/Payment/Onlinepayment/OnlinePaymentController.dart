import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../../core/App_Routes/app_routes.dart';
import '../../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../../service/api_url.dart';
import '../../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import 'Onlinepayment.dart';

class OnlinePaymentController extends GetxController {
  final isLoading = false.obs;

  // ✅ UPDATED: Refactored to use Stripe Payment Sheet
  Future<void> makePayment(AppointmentModel2 appointment) async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.onlinePay}${appointment.id}");

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final clientSecret = data["data"]["clientSecret"];
        await _makeStripePayment(
          clientSecret: clientSecret,
          appointment: appointment,
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

  // ✅ ADDED: Stripe payment sheet logic
  Future<void> _makeStripePayment({
    required String clientSecret,
    required AppointmentModel2 appointment,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "TXME",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      Get.snackbar(
        "Success",
        "€${appointment.totalCost} Payment Successful",
        snackPosition: SnackPosition.TOP,
      );

      Get.off(() => Providerpaymentsuccessful(), arguments: appointment);
    } on StripeException catch (e) {
      debugPrint("❌ Stripe Error: ${e.error.message}");
      Get.off(() => Onlinepayment(), arguments: appointment);
    }
  }
}
