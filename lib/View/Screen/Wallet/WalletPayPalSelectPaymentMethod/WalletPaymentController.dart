import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletPaymentController extends GetxController {
  // Available balance
  var balance = "€0.00".obs;

  // Selected card data
  var selectedCardData = {}.obs;

  // Amount to pay
  TextEditingController amountController = TextEditingController();

  // Optional message
  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  // Simulate fetching balance from API
  void fetchBalance() async {
    await Future.delayed(Duration(seconds: 1));
    balance.value = "€2,450.00"; // Replace with API
  }

  // Select a card
  void selectCard(Map<String, dynamic> cardData) {
    selectedCardData.value = cardData;
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
