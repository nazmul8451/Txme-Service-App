import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../core/App_Routes/app_routes.dart';
import '../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../MyBooking/PaymentSuccessful/ProviderPaymentSuccessful.dart';

class ProviderHomeController extends GetxController {

  var searchController = TextEditingController();
  var name = "".obs;
  var notificationCount = 0.obs;

  final isLoading = false.obs;
  bool _alreadyRedirected = false;

  @override
  void onInit() {
    super.onInit();
    fetchUnreadNotificationCount();
  }

  @override
  void onReady() {
    super.onReady();
    checkAgain();
  }

  void checkAgain() {
    if (_alreadyRedirected) return;
    fetchCurrentAppointmentStatus();
  }

  Future<void> fetchUnreadNotificationCount() async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.notificationCount),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          if (data['data'] is int) {
            notificationCount.value = data['data'];
          } else if (data['data'] is Map) {
            notificationCount.value = data['data']['unreadCount'] ?? 0;
          }
        }
      } else {
        print('Failed to fetch notification count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notification count: $e');
    }
  }

  Future<void> fetchCurrentAppointmentStatus() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}${ApiConstant.currentAppointment}",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body);

      if (body['success'] != true || body['data'] == null) return;

      await _handleReviewRedirect(
        status: body['data']['status'],
        appointmentData: body['data'],
      );
    } catch (e) {
      debugPrint("❌ HomeController error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleReviewRedirect({
    required String status,
    required Map<String, dynamic> appointmentData,
  }) async {
    if (_alreadyRedirected) return;

    final userRole =
    await SharePrefsHelper.getString(SharePrefsHelper.userRole);

    final needReview =
        status == "review_pending" ||
            (status == "provider_review_pending" &&
                userRole == "PROVIDER") ||
            (status == "customer_review_pending" &&
                userRole == "CUSTOMER");

    if (!needReview) return;

    _alreadyRedirected = true;

    final appointment =
    AppointmentModel2.fromJson(appointmentData, userRole: userRole);

    Get.offAll(
          () => Providerpaymentsuccessful(),
      arguments: appointment,
    );
  }
}
