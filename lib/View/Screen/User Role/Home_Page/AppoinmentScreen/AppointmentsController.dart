import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'AppointmentModel/AppointmentModel2.dart';

class AppointmentsController extends GetxController {
  final appointments = <AppointmentModel2>[].obs;
  final isLoading = false.obs;

  final userRole = "".obs;
  final userId = "".obs;

  IO.Socket? socket;

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
  }

  /// 🔌 SOCKET INIT
  void _initSocket() {
    socket = IO.io(
      ApiConstant.socketUrl, // e.g. http://10.10.7.26:5002
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint("✅ Socket Connected");

      ///  appointmentUpdate:<userId>
      socket!.on("appointmentUpdate:${userId.value}", (data) {
        debugPrint("📡 Appointment Update Received: $data");
        loadData(); //  refresh list
      });
    });

    socket!.onDisconnect((_) {
      debugPrint("❌ Socket Disconnected");
    });
  }

  /// 📥 LOAD APPOINTMENTS
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
              "confirmed": 4,
              "cancelled": 5,
              "accepted": 3,
              "in_progress": 1,
              "work_completed": 2,
            };
            return (order[a.status] ?? 99) -
                (order[b.status] ?? 99);
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Appointment Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }
}
