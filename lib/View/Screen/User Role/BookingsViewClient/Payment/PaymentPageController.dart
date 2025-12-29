import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../Service Provider Role/MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';
import 'PaymentSuccessful/PaymentSuccessful.dart';

class Paymentpagecontroller extends GetxController {
  final isLoading = false.obs;
  final bookingStatus = "".obs;

  Timer? _pollingTimer;

  /// ================== ACCEPT BOOKING ==================
  Future<void> acceptBooking(String appointmentId) async {
    try {
      if (isLoading.value) return;

      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.appointmentUpdate}$appointmentId",
      );

      debugPrint("🔗 FINAL URL => $uri");

      final res = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": "cashPayment"}),
      );

      debugPrint("📡 STATUS => ${res.statusCode}");
      debugPrint("📨 BODY => ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        _startPolling(appointmentId); //  wait for cashReceived
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint("❌ ERROR => $e");
      isLoading.value = false;
    }
  }

  /// ================== POLLING SERVER ==================
  void _startPolling(String appointmentId) {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
          (timer) async {
        final status = await _getBookingStatus(appointmentId);

        bookingStatus.value = status;
        debugPrint("⏳ CURRENT STATUS => $status");

        if (status == "cashReceived") {
          timer.cancel();
          isLoading.value = false;

          /// 🔥 AUTO NAVIGATION
          Get.off(
                () => Providerpaymentsuccessful(),
            arguments: Get.arguments,
          );
        }
      },
    );
  }

  /// ================== GET STATUS API ==================
  Future<String> _getBookingStatus(String appointmentId) async {
    try {
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.appointmentMyAppointments}$appointmentId",
      );

      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return body['data']['status'] ?? "";
      }
      return "";
    } catch (e) {
      debugPrint("❌ STATUS CHECK ERROR => $e");
      return "";
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}
