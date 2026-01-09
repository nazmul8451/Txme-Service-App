import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:txme_app/service/socket_service.dart';
import '../../Screen/User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';
import '../../Screen/User Role/Home_Page/AppoinmentScreen/AppointmentsController.dart';

class JobTimerController extends GetxController {
  Timer? _timer;
  Worker? _appointmentWorker;
  SocketApi? _socketApi;
  String? _eventName;
  String? _currentAppointmentId;

  final seconds = 0.obs;
  final isRunning = false.obs;

  DateTime? _startDateTime;

  /// 🔗 INIT FROM API MODEL WITH SOCKET
  void initFromAppointment(AppointmentModel2 appointment) {
    _currentAppointmentId = appointment.id;
    _updateTimerFromAppointment(appointment);
    _setupSocketListener();
  }

  /// 🔌 SETUP SOCKET LISTENER
  void _setupSocketListener() {
    try {
      final appController = Get.find<AppointmentsController>();

      // Initialize socket
      try {
        _socketApi = Get.find<SocketApi>();
      } catch (e) {
        _socketApi = SocketApi();
        Get.put(_socketApi!);
      }

      _eventName = "appointmentUpdate::${appController.userId.value}";

      debugPrint("🔌 JobTimer listening to: $_eventName");

      // Listen to socket events
      _socketApi!.on(_eventName!, (data) {
        debugPrint("📡 JobTimer received socket update: $data");
        appController.loadData(silent: true);
      });

      // Listen to appointment changes
      _appointmentWorker = ever(
        appController.appointments,
            (List<AppointmentModel2> list) {
          if (_currentAppointmentId == null) return;

          final updated = list.firstWhereOrNull(
                (e) => e.id == _currentAppointmentId,
          );

          if (updated != null) {
            debugPrint("📊 JobTimer: Appointment updated - Status: ${updated.status}");
            _updateTimerFromAppointment(updated);
          }
        },
      );
    } catch (e) {
      debugPrint("❌ JobTimer socket setup error: $e");
    }
  }

  /// 🔄 UPDATE TIMER FROM APPOINTMENT
  void _updateTimerFromAppointment(AppointmentModel2 appointment) {
    /// 🛑 If job already completed
    if (appointment.actualEndTime != null &&
        appointment.totalWorkedTime != null) {
      debugPrint("✅ Job completed - Total time: ${appointment.totalWorkedTime}");
      stopFromApi(appointment.totalWorkedTime!);
      return;
    }

    /// ▶️ Job in progress
    if (appointment.actualStartTime != null) {
      debugPrint("▶️ Job in progress - Start time: ${appointment.actualStartTime}");
      _startDateTime = _parseTimeToday(appointment.actualStartTime!);

      final diff = DateTime.now().difference(_startDateTime!);
      seconds.value = diff.inSeconds > 0 ? diff.inSeconds : 0;

      if (!isRunning.value) {
        _startLiveTimer();
      }
    } else {
      // Job not started yet
      debugPrint("⏸️ Job not started yet");
      reset();
    }
  }

  /// ▶️ LIVE TIMER
  void _startLiveTimer() {
    if (isRunning.value) return;

    debugPrint("▶️ Starting live timer");
    isRunning.value = true;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds.value++;
    });
  }

  /// 🛑 MANUAL START (when user clicks start)
  void start() {
    if (isRunning.value) return;

    _startDateTime = DateTime.now();
    _startLiveTimer();
  }

  /// ⛔ MANUAL STOP (returns total seconds for API)
  int stop() {
    debugPrint("⛔ Stopping timer manually");
    _timer?.cancel();
    isRunning.value = false;
    return seconds.value;
  }

  /// ⛔ STOP FROM API (when API sends actualEndTime)
  void stopFromApi(double totalWorkedTime) {
    debugPrint("⛔ Stopping timer from API - Total: $totalWorkedTime hrs");
    _timer?.cancel();
    isRunning.value = false;
    seconds.value = _workedTimeToSeconds(totalWorkedTime);
  }

  /// 🔄 RESET (new job)
  void reset() {
    debugPrint("🔄 Resetting timer");
    _timer?.cancel();
    seconds.value = 0;
    isRunning.value = false;
    _startDateTime = null;
  }

  /// ⏱️ UI TIME
  String get formattedTime {
    final h = (seconds.value ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds.value % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  /// 📡 API PAYLOAD (END JOB)
  Map<String, int> get timePayload => {
    "hours": seconds.value ~/ 3600,
    "minutes": (seconds.value % 3600) ~/ 60,
    "seconds": seconds.value % 60,
  };

  /// 📊 Get total hours as decimal (for API)
  double get totalHours => seconds.value / 3600;

  // ---------------- HELPERS ----------------

  DateTime _parseTimeToday(String time) {
    try {
      return DateTime.parse(time);
    } catch (e) {
      debugPrint("❌ Error parsing time in JobTimerController: $e");
      return DateTime.now();
    }
  }

  int _workedTimeToSeconds(double value) {
    final hours = value.floor();
    final minutes = ((value - hours) * 60).round();
    return (hours * 3600) + (minutes * 60);
  }

  @override
  void onClose() {
    debugPrint("🔌 Cleaning up JobTimer socket listener");

    // Remove socket listener
    if (_socketApi != null && _eventName != null) {
      _socketApi!.off(_eventName!);
    }

    // Dispose worker
    _appointmentWorker?.dispose();

    // Cancel timer
    _timer?.cancel();

    super.onClose();
  }
}