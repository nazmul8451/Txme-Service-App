import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Confirmpaymentcontroller extends GetxController {
  // Routing Number (Reactive)

  var totalAmount = ''.obs;

  // Note TextField Controller
  TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Example: API থেকে বা অন্য জায়গা থেকে routing number set করা

    totalAmount.value = "€87.00";
  }

  @override
  void onClose() {
    noteController.dispose(); // Memory leak এড়াতে dispose করা
    super.onClose();
  }
}
