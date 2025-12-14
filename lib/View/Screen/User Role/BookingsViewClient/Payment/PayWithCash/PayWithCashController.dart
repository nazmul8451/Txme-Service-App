import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Paywithcashcontroller extends GetxController {
  //  API theke asbe data
  var recipientName = "".obs;
  var accountNumber = "".obs;
  var routingNumber = "".obs;
  var amount = "".obs;

  //  User input
  TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPaymentData();
  }

  //  API theke data fetch simulation
  void fetchPaymentData() {
    // এখানে তোমার API call হবে, এখন sample data দেওয়া হলো
    recipientName.value = "Michelle R.";
    accountNumber.value = "4000 1234 5678 9010";
    routingNumber.value = "€87.00";
    amount.value = "€87.00";
  }

  //  Submit function
  void submitPayment() {
    // এখানে তুমি API call করে payment করতে পারো
    print("Recipient Name: ${recipientName.value}");
    print("Account Number: ${accountNumber.value}");
    print("Routing Number: ${routingNumber.value}");
    print("Amount: ${amount.value}");
    print("Note: ${noteController.text}");
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
