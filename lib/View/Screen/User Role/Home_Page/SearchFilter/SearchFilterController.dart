import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';

class SearchFilterController extends GetxController {
  // ✅ Time and Date are now nullable
  final fromTime = Rx<TimeOfDay?>(null);
  final toTime = Rx<TimeOfDay?>(null);
  final selectedDate = Rx<DateTime?>(null);

  // Sliders
  final minPrice = 0.0.obs;
  final maxPrice = 500.0.obs;
  final radius = 5.0.obs;

  // Service Type and Language
  final selectedService = "ALL".obs;
  final List<String> serviceItems = ["ALL", "wiring", "repairs", "emergency", "installations"];
  final languagesSpokenController = TextEditingController();
  final serviceTypeController = TextEditingController();

  void setPriceRange(RangeValues values) {
    minPrice.value = values.start;
    maxPrice.value = values.end;
  }
  void setRadius(double value) => radius.value = value;

  Future<void> pickTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? fromTime.value ?? TimeOfDay.now() : toTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      if (isFrom) fromTime.value = picked; else toTime.value = picked;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void clearFilters() {
    fromTime.value = null;
    toTime.value = null;
    selectedDate.value = null;
    minPrice.value = 0;
    maxPrice.value = 500;
    radius.value = 5.0;
    selectedService.value = "ALL";
    languagesSpokenController.clear();
    serviceTypeController.clear();
  }

  void applyFilters() {
    final Map<String, String> queryParams = {};

    // ✅ Only add parameters if they have been set by the user
    if (selectedDate.value != null) {
      queryParams['availableDate'] = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    }
    if (fromTime.value != null) {
      queryParams['startTime'] = "${fromTime.value!.hour.toString().padLeft(2, '0')}:${fromTime.value!.minute.toString().padLeft(2, '0')}";
    }
    if (toTime.value != null) {
      queryParams['endTime'] = "${toTime.value!.hour.toString().padLeft(2, '0')}:${toTime.value!.minute.toString().padLeft(2, '0')}";
    }
    
    queryParams['minPrice'] = minPrice.value.round().toString();
    queryParams['maxPrice'] = maxPrice.value.round().toString();
    queryParams['radius'] = radius.value.round().toString();

    if (selectedService.value != "ALL") {
       queryParams['providerProfile.serviceCategory'] = selectedService.value;
    }
    
    if (languagesSpokenController.text.isNotEmpty) {
      queryParams['providerProfile.languages'] = languagesSpokenController.text;
    }
    
    if (serviceTypeController.text.isNotEmpty) {
        queryParams['searchTerm'] = serviceTypeController.text;
    }

    Get.toNamed(AppRoute.electricianproviders, arguments: queryParams);
  }
}
