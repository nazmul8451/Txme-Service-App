import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';

class ReviewController extends GetxController {
  final isLoading = false.obs;

  final commentController = TextEditingController();
  final rating = 0.obs;

  /// ⭐ SET RATING
  void setRating(int value) {
    rating.value = value;
  }

  /// ================= POST REVIEW =================
  Future<bool> submitReview(AppointmentModel2 appointment) async {
    if (rating.value == 0) {
      Get.snackbar(
        "Rating required",
        "Please select a rating",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final token =
    await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Unauthorized user");
      return false;
    }

    try {
      isLoading.value = true;

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.postReview}",
      );

      /// 🔥 FINAL PAYLOAD (CORRECT & SAFE)
      final payload = {
        "reviewee": appointment.displayPersonId, // opposite person
        "appointment": appointment.id,
        "service": appointment.description,
        "rating": rating.value,
        "comment": commentController.text.trim(),
      };

      debugPrint("🟡 REVIEW PAYLOAD => $payload");

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS => ${response.statusCode}");
      debugPrint("📨 BODY => ${response.body}");

      final body = jsonDecode(response.body);

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          body['success'] == true) {
        return true;
      }

      Get.snackbar(
        "Failed",
        body['message'] ?? "Review submission failed",
      );
      return false;
    } catch (e) {
      debugPrint("❌ REVIEW ERROR => $e");
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
