import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Editprofileprofessioncontroller extends GetxController {

  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 13, minute: 0);
  DateTime? selectedDate;

  final serviceNameController = TextEditingController();

  Rx<RangeValues> radius = const RangeValues(0, 10).obs;

  Future<void> pickTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? fromTime : toTime,
    );

    if (picked != null) {
      if (isFrom) {
        fromTime = picked;
      } else {
        toTime = picked;
      }
      update(); // 🔥 UI refresh
    }
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDate = picked;
      update(); // 🔥 UI refresh
    }
  }
}
