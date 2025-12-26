import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../../service/api_url.dart';
import '../../AppoinmentScreen/BookingScheduleBinding.dart';
import '../../AppoinmentScreen/ScheduleBookingPage.dart';

class RequestBookingController extends GetxController {
  /// loading
  final isLoading = false.obs;

  /// api data
  final workingDays = <String>[].obs;
  final unavailableDates = <DateTime>[].obs;

  /// selected date
  final selectedDate = Rxn<DateTime>();

  /// provider id
  late final String providerId;

  @override
  void onInit() {
    super.onInit();
    providerId = Get.arguments;
    fetchProviderAvailability();
  }


  /// ================= API =================
  Future<void> fetchProviderAvailability() async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final url = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.allProviderUser}/$providerId",
      );

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final provider = body['data'];
        final profile = provider['providerProfile']; //  FIX

        /// -------- working days --------
        final List<dynamic>? days = profile?['workingDays'];
        if (days != null && days.isNotEmpty) {
          workingDays.assignAll(days.cast<String>());
        } else {
          workingDays.clear(); // null = all allowed
        }

        /// -------- unavailable dates --------
        final List<dynamic>? dates = profile?['unavailableDates'];
        if (dates != null && dates.isNotEmpty) {
          unavailableDates.assignAll(
            dates.map((e) => DateTime.parse(e)).toList(),
          );
        } else {
          unavailableDates.clear();
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }




  /// ================= LOGIC =================

  bool isWorkingDay(DateTime date) {
    if (workingDays.isEmpty) return true;

    final dayName = DateFormat('EEEE').format(date);
    return workingDays.contains(dayName);
  }

  bool isUnavailable(DateTime date) {
    return unavailableDates.any(
          (d) =>
      d.year == date.year &&
          d.month == date.month &&
          d.day == date.day,
    );
  }

  bool isDaySelectable(DateTime date) {
    if (!isWorkingDay(date)) return false;
    if (isUnavailable(date)) return false;
    return true;
  }

  void selectDate(DateTime date) {
    if (!isDaySelectable(date)) return;

    selectedDate.value = date;

    /// 🔥 CLOSE MODAL FIRST
    Get.back();

    /// 🔥 NAVIGATE AFTER FRAME
    Future.microtask(() {
      Get.to(
            () => BookingSchedulePage(),
        binding: BookingScheduleBinding(),
        arguments: {
          "providerId": providerId,
          "selectedDate": date,
        },
      );
    });
  }


}
