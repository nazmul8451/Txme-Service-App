import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'TimeSlot.dart';

class BookingScheduleController extends GetxController {
  final isLoading = false.obs;

  late String providerId;
  late DateTime selectedDate;
  late String service;

  final dates = <Map<String, dynamic>>[].obs;
  final selectedIndex = 2.obs;
  /// ✅ MODEL LIST
  final slots = <TimeSlot>[].obs;

  final selectedSlotIndex = (-1).obs;

  void onSlotTap(int index) {
    selectedSlotIndex.value = index;
  }


  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    providerId = args["providerId"] ?? "";
    selectedDate = args["selectedDate"] ?? DateTime.now();
    service = args["service"] ?? "";

    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("🆔 providerId = $providerId");
    print("📅 selectedDate = $selectedDate");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    _generateDates();
    fetchSlots(selectedDate);
  }

  /// -------- generate dates --------
  void _generateDates() {
    dates.clear();

    for (int i = -2; i <= 2; i++) {
      final date = selectedDate.add(Duration(days: i));
      dates.add({
        "date": date,
        "day": date.day,
        "week": DateFormat('EE').format(date),
      });
    }

    print("📆 Dates generated: ${dates.length}");
  }

  /// -------- API --------
  Future<void> fetchSlots(DateTime date) async {
    try {
      isLoading.value = true;
      slots.clear();

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      /// 🔥 BUILD URI
      final uri = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.providerCalendar}/$providerId/calendar",
      ).replace(
        queryParameters: {
          "date": formattedDate,
        },
      );

      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("🌍 API URL => $uri");
      print("🪪 TOKEN => Bearer $token");
      print("📅 DATE => $formattedDate");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      /// 🔥 API CALL
      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 StatusCode => ${res.statusCode}");
      print("📦 Raw Response => ${res.body}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        print("✅ Decoded Response => $body");

        if (body["success"] == true && body["data"] != null) {
          final List data = body["data"];

          print("📊 Slot count => ${data.length}");

          for (final item in data) {
            print("⏰ Slot JSON => $item");
            slots.add(TimeSlot.fromJson(item));
          }
        } else {
          print("⚠️ success=false OR data=null");
        }
      } else {
        print(" API FAILED => ${res.statusCode}");
      }
    } catch (e, s) {
      print(" EXCEPTION => $e");
      print(" STACKTRACE => $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmBooking() async {
    try {
      isLoading.value = true;

      final index = selectedSlotIndex.value;
      if (index == -1) return;

      final slot = slots[index];

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);
      print(ApiConstant.baseUrl);

      final formattedDate =
      DateFormat('yyyy-MM-dd').format(selectedDate);

      final body = {
        "provider": providerId,
        "service": service,
        "date": formattedDate,
        "startTime": slot.startTime,
        "endTime": slot.endTime,
      };

      print("📤 CONFIRM BOOKING BODY => $body");

      final res = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.appointmentCreate}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      Get.offAllNamed(AppRoute.appointmentsPage);

      print("📡 StatusCode => ${res.statusCode}");
      print("📦 Response => ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("Success", "Booking Confirmed ✅");
      } else {
        Get.snackbar("Error", "Booking Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }



  /// -------- tap date --------
  void onDateTap(int index) {
    selectedIndex.value = index;
    selectedDate = dates[index]["date"];
    selectedSlotIndex.value = -1; //  reset slot
    fetchSlots(selectedDate);
  }


  /// -------- UI helper --------
  double getTopPosition(String startTime) {
    final parts = startTime.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final position = ((hour + minute / 60) - 8) * 55;

    print("📐 topPosition($startTime) => $position");

    return position;
  }
}
