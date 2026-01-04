import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../../../service/socket_service.dart';
import '../../../../Widgegt/JobProgressTime/JobTimerController.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../../User Role/Home_Page/AppoinmentScreen/AppointmentsController.dart';
import '../ConfirmPayment/ConfirmPayment.dart';
import '../PaymentSuccessful/ProviderPaymentSuccessful.dart';

class Providertoraldurationcontroller extends GetxController {
  final isLoading = false.obs;
  final SocketApi socketApi = Get.find<SocketApi>();
  String? userId;
  String? _eventName;

  /// ================== INITIALIZE SOCKET LISTENER ==================
  void initSocketListener(AppointmentModel2 appointment) async {
    userId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    if (userId == null || userId!.isEmpty) {
      debugPrint("❌ Cannot listen to socket: userId is empty");
      return;
    }

    _eventName = "appointmentUpdate::${userId!}";
    debugPrint("🎧 Listening to Job Event: $_eventName");

    socketApi.on(_eventName!, (data) {
      debugPrint("📡 Job Update Received: $data");
      final updatedAppointmentData = data['appointment'] ?? data;

      if (updatedAppointmentData['_id'] == appointment.id) {
        final userRole = Get.find<AppointmentsController>().userRole.value;
        final updatedAppointment = AppointmentModel2.fromJson(updatedAppointmentData, userRole: userRole);

        Get.find<JobTimerController>().initFromAppointment(updatedAppointment);

        if (updatedAppointment.status != appointment.status) {
           _handleAutoNavigation(updatedAppointment, userRole);
        }
      }
    });
  }

  /// ================== HANDLE AUTO-NAVIGATION ==================
  void _handleAutoNavigation(AppointmentModel2 appointment, String role) {
    final status = appointment.status.toLowerCase();

    if (status == 'work_completed' || status == 'awaiting_payment') {
      Get.off(() => ConfirmPaymentpage(), arguments: appointment);
    } else if (status == 'completed') {
      Get.off(() => Providerpaymentsuccessful(), arguments: appointment);
    } else if (status == 'cancelled' || status == 'rejected') {
      Get.back();
      Get.snackbar("Update", "This job has been cancelled.");
    }
  }

  /// ================== ACCEPT BOOKING (END JOB) ==================
  Future<bool> acceptBooking(String appointmentId) async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.appointmentUpdate}$appointmentId");

      final res = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": "work_completed"}),
      );

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

  @override
  void onClose() {
    if (_eventName != null) {
      socketApi.off(_eventName!);
      debugPrint("🛑 Stopped Listening to Job Event: $_eventName");
    }
    super.onClose();
  }
}
