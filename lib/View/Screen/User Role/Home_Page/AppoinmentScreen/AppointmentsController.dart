import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../../../service/socket_service.dart';
import 'AppointmentModel/AppointmentModel2.dart';

class AppointmentsController extends GetxController {
  final appointments = <AppointmentModel2>[].obs;
  final isLoading = false.obs;

  final userRole = "".obs;
  final userId = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  ///  CALL THIS AFTER LOGIN / PAGE OPEN
  Future<void> loadAll() async {
    await _loadUserInfo();
    await loadData();
    _initSocket();
  }

  /// 👤 LOAD ROLE + USER ID
  Future<void> _loadUserInfo() async {
    userRole.value =
        await SharePrefsHelper.getString(SharePrefsHelper.userRole) ?? "";

    userId.value =
        await SharePrefsHelper.getString(SharePrefsHelper.userId) ?? "";
    
    debugPrint("👤 User Info Loaded: Role=${userRole.value}, ID=${userId.value}");
  }

  /// 📥 LOAD APPOINTMENTS
  Future<void> loadData({bool silent = false}) async {
    try {
      if (!silent) isLoading.value = true;

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
                .map(
                  (e) => AppointmentModel2.fromJson(
                e,
                userRole: userRole.value,
              ),
            )
                .toList(),
          );

          ///  SORT ORDER
          appointments.sort((a, b) {
            const order = {
              "pending": 0,
              "in_progress": 1,
              "work_completed": 2,
              "accepted": 3,
              "confirmed": 4,
              "completed": 5, // ✅ ADDED
              "cancelled": 6,
            };
            return (order[a.status] ?? 99) -
                (order[b.status] ?? 99);
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Appointment Error: $e");
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  /// 🔌 SOCKET INIT
  void _initSocket() async {
    final socketApi = SocketApi();
    await socketApi.init();

    if (userId.value.isEmpty) {
       await _loadUserInfo();
    }

    if (userId.value.isEmpty) {
      debugPrint("⚠️ Cannot listen to socket: userId is empty");
      return;
    }

    final eventName = "appointmentUpdate::${userId.value}";
    debugPrint("🎧 Listening to Appointment Event: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📡 Appointment Update Received [$eventName]: $data");
      loadData(silent: true); // refresh list silently
    });
  }

  @override
  void onClose() {
    final eventName = "appointmentUpdate::${userId.value}";
    SocketApi().off(eventName);
    super.onClose();
  }
}
