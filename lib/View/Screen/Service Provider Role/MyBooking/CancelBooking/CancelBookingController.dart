import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelBookingController extends GetxController {
  /// Selected reason
  RxString selectedReason = "".obs;

  /// Note controller (Only for Other)
  TextEditingController noteController = TextEditingController();

  /// Reason list (API-friendly)
  final List<String> reasons = [
    "Scheduling conflict",
    "Service no longer needed",
    "Unavailable on the requested date",
    "Other",
  ];

  /// Select reason
  void selectReason(String value) {
    selectedReason.value = value;

    // Other না হলে note clear
    if (value != "Other") {
      noteController.clear();
    }
  }

  /// Payload for API
  Map<String, dynamic> get cancelPayload {
    return {
      "reason": selectedReason.value,
      "note": selectedReason.value == "Other"
          ? noteController.text
          : null,
    };
  }

  /// Submit (later API call here)
  void confirmCancellation() {
    debugPrint("Cancel Payload => $cancelPayload");

    // TODO: API CALL
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
