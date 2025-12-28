import 'dart:async';
import 'package:get/get.dart';
import '../../Screen/User Role/Home_Page/AppoinmentScreen/AppointmentModel/AppointmentModel2.dart';


class JobTimerController extends GetxController {
  Timer? _timer;

  final seconds = 0.obs;
  final isRunning = false.obs;

  DateTime? _startDateTime;

  /// 🔗 INIT FROM API MODEL
  void initFromAppointment(AppointmentModel2 appointment) {
    /// 🛑 If job already completed
    if (appointment.actualEndTime != null &&
        appointment.totalWorkedTime != null) {
      seconds.value =
          _workedTimeToSeconds(appointment.totalWorkedTime!);
      isRunning.value = false;
      return;
    }

    /// ▶️ Job in progress
    if (appointment.actualStartTime != null) {
      _startDateTime =
          _parseTimeToday(appointment.actualStartTime!);

      final diff =
      DateTime.now().difference(_startDateTime!);

      seconds.value = diff.inSeconds > 0 ? diff.inSeconds : 0;
      _startLiveTimer();
    }
  }

  /// ▶️ LIVE TIMER
  void _startLiveTimer() {
    if (isRunning.value) return;

    isRunning.value = true;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds.value++;
    });
  }

  /// ⛔ STOP (when API sends actualEndTime)
  void stopFromApi(double totalWorkedTime) {
    _timer?.cancel();
    isRunning.value = false;
    seconds.value = _workedTimeToSeconds(totalWorkedTime);
  }

  /// 🔄 RESET (new job)
  void reset() {
    _timer?.cancel();
    seconds.value = 0;
    isRunning.value = false;
    _startDateTime = null;
  }

  /// ⏱️ UI TIME
  String get formattedTime {
    final h = (seconds.value ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds.value % 3600) ~/ 60)
        .toString()
        .padLeft(2, '0');
    final s = (seconds.value % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  /// 📡 API PAYLOAD (END JOB)
  Map<String, int> get timePayload => {
    "hours": seconds.value ~/ 3600,
    "minutes": (seconds.value % 3600) ~/ 60,
    "seconds": seconds.value % 60,
  };

  // ---------------- HELPERS ----------------

  DateTime _parseTimeToday(String time) {
    final parts = time.split(':');
    return DateTime.now().copyWith(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
      second: 0,
    );
  }

  int _workedTimeToSeconds(double value) {
    final hours = value.floor();
    final minutes = ((value - hours) * 60).round();
    return (hours * 3600) + (minutes * 60);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
