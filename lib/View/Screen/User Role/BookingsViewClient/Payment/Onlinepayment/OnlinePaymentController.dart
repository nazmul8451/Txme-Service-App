import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../../service/api_url.dart';
import '../../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import '../../../Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../PaymentSuccessful/PaymentSuccessful.dart';

class OnlinePaymentController extends GetxController {
  final isLoading = false.obs;

  Future<void> makePayment(AppointmentModel2 appointment) async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.onlinePay}${appointment.id}");

      debugPrint("Making online payment to: $uri");

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("Online Payment Status: ${response.statusCode}");
      debugPrint("Online Payment Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // On API success, navigate to the success screen.
        Get.off(() => Providerpaymentsuccessful(), arguments: appointment);
      } else {
        Get.snackbar(
          "Payment Failed",
          "Could not process online payment. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Online Payment Error: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
