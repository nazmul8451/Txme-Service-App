import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

class NewBookingRequestController extends GetxController {
  final isLoading = false.obs;

  /// ================== ACCEPT BOOKING ==================
  Future<bool> acceptBooking(String appointmentId) async {
    try {
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
        body: jsonEncode({"status": "accepted"}),
      );

      debugPrint("📡 STATUS => ${res.statusCode}");
      debugPrint("📨 BODY => ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        return body['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ ERROR => $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}
