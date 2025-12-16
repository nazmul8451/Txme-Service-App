import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sendpagecontroller extends GetxController {
  // TextField controllers
  final ammountController = TextEditingController();
  final nameController = TextEditingController();
  final messageController = TextEditingController();

  // Selected payment method index
  var selectedPaymentIndex = 1.obs;

  // Available balance
  var balance = "€0.00".obs;

  // New card data
  var newCardData = {}.obs;

  /// Select payment method
  void selectPaymentMethod(int index) {
    selectedPaymentIndex.value = index;
  }

  /// Add new card
  void addNewCard(Map<String, dynamic> cardData) {
    newCardData.value = cardData;
  }

  /// Simulate fetching balance from API
  void fetchBalance() async {
    await Future.delayed(Duration(seconds: 1));
    balance.value = "€2,450.00"; // Replace with API call
  }

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  @override
  void onClose() {
    ammountController.dispose();
    nameController.dispose();
    messageController.dispose();
    super.onClose();
  }
}













