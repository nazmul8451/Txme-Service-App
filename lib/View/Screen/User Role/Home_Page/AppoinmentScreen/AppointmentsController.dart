import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'AppointmentModel/AppointmentModel2.dart';

class AppointmentsController extends GetxController {
  final appointments = <AppointmentModel2>[].obs;
  final isLoading = false.obs;
  final userRole = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  /// 🔁 CALL THIS AFTER LOGIN / PAGE OPEN
  Future<void> loadAll() async {
    await _loadRole();
    await loadData();
  }

  Future<void> _loadRole() async {
    userRole.value =
        await SharePrefsHelper.getString(SharePrefsHelper.userRole) ?? "";
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(
        SharePrefsHelper.bearerToken,
      );

      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.appointmentMyAppointments}",
      );

      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        if (body['success'] == true &&
            body['data']?['result'] is List) {
          appointments.assignAll(
            (body['data']['result'] as List)
                .map((e) => AppointmentModel2.fromJson(
              e,
              userRole: userRole.value,
            ))
                .toList(),
          );

          /// 🔥 SORT: Pending → Confirmed → Cancelled
          appointments.sort((a, b) {
            const order = {
              "pending": 0,
              "confirmed": 1,
              "cancelled": 2,
            };
            return order[a.status]! - order[b.status]!;
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Appointment Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

}



