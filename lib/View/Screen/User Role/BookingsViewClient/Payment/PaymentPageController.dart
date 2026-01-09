import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class Paymentpagecontroller extends GetxController {
  final isLoading = false.obs;
  Timer? _pollingTimer;

  /// ================== ACCEPT BOOKING ==================
  Future<void> acceptBooking(String appointmentId) async {
    try {
      if (isLoading.value) return;

      isLoading.value = true;

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.appointmentUpdate}$appointmentId",
      );

      debugPrint("🔗 Cash Payment URL => $uri");

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
        final body = jsonDecode(res.body);

        if (body['success'] == true) {
          Get.snackbar(
            "Success",
            "Waiting for provider to confirm payment...",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );

          // ✅ Start polling as backup (if socket fails)
          _startPolling(appointmentId);
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            body['message'] ?? "Failed to initiate cash payment",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Failed to initiate cash payment",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("❌ CASH PAYMENT ERROR => $e");
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ================== POLLING (BACKUP) ==================
  void _startPolling(String appointmentId) {
    _pollingTimer?.cancel();

    int attempts = 0;
    const maxAttempts = 60; // 5 minutes (60 * 5 seconds)

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
          (timer) async {
        attempts++;

        final status = await _getBookingStatus(appointmentId);
        debugPrint("⏳ Polling attempt $attempts/$maxAttempts - Status: $status");

        if (status == "cashReceived" ||
            status == "review_pending" ||
            status == "customer_review_pending") {

          debugPrint("✅ Payment confirmed via polling");
          timer.cancel();
          isLoading.value = false;

          // Socket listener will handle navigation
          // No need to navigate here

        } else if (attempts >= maxAttempts) {
          debugPrint("⏱️ Polling timeout");
          timer.cancel();
          isLoading.value = false;

          Get.snackbar(
            "Timeout",
            "Payment confirmation is taking longer than expected. Please check your bookings.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
        }
      },
    );
  }

  /// ================== GET STATUS API ==================
  Future<String> _getBookingStatus(String appointmentId) async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.appointmentMyAppointments}$appointmentId",
      );

      final res = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
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

  /// ✅ Stop polling (called from UI when socket receives update)
  void stopPolling() {
    debugPrint("🛑 Stopping polling");
    _pollingTimer?.cancel();
    isLoading.value = false;
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}