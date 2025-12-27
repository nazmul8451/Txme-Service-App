import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'AppointmentModel/AppointmentModel2.dart';

class AppointmentsController extends GetxController {
  final appointments = <AppointmentModel2>[].obs;
  final isLoading = false.obs;

  /// USER ROLE (CUSTOMER / PROVIDER)
  final userRole = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadRole();
    loadData();
  }

  /// ================== LOAD ROLE ==================
  Future<void> _loadRole() async {
    userRole.value =
        await SharePrefsHelper.getString(SharePrefsHelper.userRole) ?? "";
  }

  /// ================== LOAD APPOINTMENTS ==================
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

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
            body['data'] != null &&
            body['data']['result'] is List) {
          appointments.assignAll(
            (body['data']['result'] as List)
                .map((e) => AppointmentModel2.fromJson(e))
                .toList(),
          );
        }
      }
    } catch (e) {
      print("❌ ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================== FILTER ==================
  List<AppointmentModel2> filter(String status) {
    return appointments
        .where((e) => e.status.toLowerCase() == status)
        .toList();
  }
}

