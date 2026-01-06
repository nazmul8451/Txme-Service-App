import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class Confirmpaymentcontroller extends GetxController {
  final isLoading = false.obs;

  Future<bool> acceptBooking(String appointmentId) async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.appointmentUpdate}$appointmentId");

      debugPrint("🔗 FINAL URL => $uri");

      final res = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": "cashReceived"}),
      );

      debugPrint("📡 STATUS => ${res.statusCode}");
      debugPrint("📨 BODY => ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        return body['success'] == true;
      } else {
        final body = jsonDecode(res.body);
        final message = body['message'] ?? "An unknown error occurred.";
        Get.snackbar(message, "", snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      debugPrint("❌ ERROR => $e");
      Get.snackbar("An unexpected error occurred.", "", snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
