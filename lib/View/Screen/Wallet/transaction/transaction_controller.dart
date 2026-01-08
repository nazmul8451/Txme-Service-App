import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // ✅ Add this import
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../WalletTransaction.dart';
import 'transaction_type.dart';

class TransactionDetailsController extends GetxController {
  final WalletTransaction tx = Get.arguments as WalletTransaction;
  final TransactionType type;

  TransactionDetailsController(this.type);

  var isLoading = true.obs;
  var isDownloading = false.obs;

  var title = ''.obs;
  var amount = ''.obs;
  var status = ''.obs;
  var dateTime = ''.obs;
  var paymentMethod = ''.obs;
  var transactionId = ''.obs;
  var amount2 = ''.obs;
  var fee = ''.obs;
  var total = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTransaction();
  }

  void _loadTransaction() async {
    isLoading(true);

    title.value = _titleFromType(type);

    amount.value = "€${tx.amount.toStringAsFixed(2)}";
    amount2.value = "€${tx.amount.toStringAsFixed(2)}";

    // ✅ Calculate total with fee
    final totalAmount = tx.amount + double.parse(tx.fee);
    total.value = "€${totalAmount.toStringAsFixed(2)}";

    status.value = _formatStatus(tx.status);
    dateTime.value = _formatDateTime(tx.createdAt); // ✅ Format date & time
    paymentMethod.value = tx.type.toUpperCase();
    transactionId.value = tx.id;

    fee.value = "€${tx.fee}";

    isLoading(false);
  }

  /// ✅ FORMAT DATE & TIME
  String _formatDateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      // Format: "12 Jan 2025, 10:30 AM"
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      debugPrint("Date parse error: $e");
      return isoDate; // Return original if parsing fails
    }
  }

  /// ✅ FORMAT STATUS
  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      default:
        return status.capitalizeFirst ?? status;
    }
  }

  /// ================= DOWNLOAD INVOICE =================
  Future<void> downloadInvoice() async {
    try {
      isDownloading(true);

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.transactionInvoice}${tx.id}";
      final uri = Uri.parse(url);

      debugPrint("📥 Downloading invoice from: $url");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("PDF received: ${response.contentLength} bytes");

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/invoice_${tx.id}.pdf');
        await file.writeAsBytes(response.bodyBytes);

        Get.snackbar(
          "Success",
          "Invoice downloaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        final result = await OpenFile.open(file.path);

        if (result.type != ResultType.done) {
          debugPrint("Error opening file: ${result.message}");
          Get.snackbar(
            "Info",
            "Invoice saved to: ${file.path}",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        debugPrint("Response body: ${response.body}");
        Get.snackbar(
          "Error",
          "Failed to download invoice. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("Invoice error => $e");
      Get.snackbar(
        "Error",
        "Invoice download failed",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading(false);
    }
  }

  String _titleFromType(TransactionType type) {
    switch (type) {
      case TransactionType.topUp:
        return "Top-Up";
      case TransactionType.withdraw:
        return "Withdraw";
      case TransactionType.send:
        return "Send";
      case TransactionType.receive:
        return "Receive";
    }
  }
}