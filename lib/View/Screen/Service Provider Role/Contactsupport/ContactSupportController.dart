import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactSupportController extends GetxController {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
