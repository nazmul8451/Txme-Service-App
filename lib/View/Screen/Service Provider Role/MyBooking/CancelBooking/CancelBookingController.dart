import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class CancelBookingController extends GetxController {
  final isLoading = false.obs;
  final selectedReason = "".obs;

  final noteController = TextEditingController();

  /// UI Reasons
  final List<String> reasons = [
    "Scheduling conflict",
    "Service no longer needed",
    "Unavailable on the requested date",
    "Other",
  ];

  void selectReason(String? value) {
    if (value == null) return;
    selectedReason.value = value;

    if (value != "Other") {
      noteController.clear();
    }
  }

  Future<bool> cancelBooking(String appointmentId) async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(
        SharePrefsHelper.bearerToken,
      );

      final role = await SharePrefsHelper.getString(
        SharePrefsHelper.userRole,
      );

      /// 🔥 ROLE BASED STATUS
      final String status =
      role == "CUSTOMER" ? "cancelled" : "rejected";

      /// 🔥 FINAL REASON (UI based)
      final String reason = selectedReason.value == "Other"
          ? noteController.text.trim()
          : selectedReason.value;

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}"
            "${ApiConstant.appointmentUpdate}$appointmentId",
      );

      final res = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "status": status,
          "reason": reason,
        }),
      );

      debugPrint("🔵 Cancel/Reject res: ${res.body}");

      final body = jsonDecode(res.body);
      return res.statusCode == 200 && body['success'] == true;
    } catch (e) {
      debugPrint("❌ Cancel/Reject error => $e");
      return false;
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
