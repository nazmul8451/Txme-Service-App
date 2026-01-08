import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';

import '../../../Wallet/WalletTransaction.dart';

class TransactionController extends GetxController {
  var transactions = <WalletTransaction>[].obs;
  var isLoading = false.obs;
  var downloadingIds = <String>[].obs; // Track which invoice is downloading

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  // ================= FETCH TRANSACTIONS =================
  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      if (token.isEmpty) {
        Get.snackbar("Error", "Please login first");
        return;
      }

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.myTransactions),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      debugPrint("Transaction Response: ${res.body}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List list = decoded['data']?['result'] ?? [];

        transactions.value = list
            .map((json) => WalletTransaction.fromJson(json))
            .toList();

        debugPrint("✅ Transactions loaded: ${transactions.length}");
      } else {
        Get.snackbar("Error", "Failed to load transactions");
      }
    } catch (e) {
      debugPrint("❌ Transaction Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= DOWNLOAD INVOICE =================
  Future<void> downloadInvoice(String transactionId) async {
    try {
      downloadingIds.add(transactionId);

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.transactionInvoice}$transactionId";
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
        final file = File('${dir.path}/invoice_$transactionId.pdf');
        await file.writeAsBytes(response.bodyBytes);

        Get.snackbar(
          "Success",
          "Invoice downloaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          debugPrint("Error opening file: ${result.message}");
          Get.snackbar(
            "Info",
            "Invoice saved. Please open it from your files.",
          );
        }
      } else {
        debugPrint("Response body: ${response.body}");
        Get.snackbar(
          "Error",
          "Failed to download invoice. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Invoice error => $e");
      Get.snackbar("Error", "Invoice download failed");
    } finally {
      downloadingIds.remove(transactionId);
    }
  }

  // Helper to check if specific invoice is downloading
  bool isDownloadingInvoice(String id) => downloadingIds.contains(id);
}