import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../../../service/socket_service.dart';

class Confirmpaymentcontroller extends GetxController {
  final isLoading = false.obs;

  // ✅ Socket instance
  late SocketApi socketApi;

  @override
  void onInit() {
    super.onInit();
    socketApi = SocketApi();
  }

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

        if (body['success'] == true) {
          // ✅ Emit socket event to notify customer in real-time
          try {
            final appointmentData = body['data'] ?? body['appointment'];

            // ✅ FIXED: Use 'emit' instead of 'ever'
            socketApi.emit('appointmentUpdate', {
              'appointmentId': appointmentId,
              'status': 'cashReceived',
              'data': appointmentData,
            });

            debugPrint("📡 Socket emitted: appointmentUpdate for $appointmentId");

            Get.snackbar(
              "Success",
              "Payment confirmed successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
            );
          } catch (socketError) {
            debugPrint("⚠️ Socket emit failed: $socketError");
            // Still return true as API call was successful
          }

          return true;
        }
        return false;
      } else {
        final body = jsonDecode(res.body);
        final message = body['message'] ?? "An unknown error occurred.";
        Get.snackbar(
          "Error",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      debugPrint("❌ ERROR => $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}