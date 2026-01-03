import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../WalletTransaction.dart';
import 'transaction_type.dart';

class TransactionDetailsController extends GetxController {

  final WalletTransaction tx = Get.arguments as WalletTransaction;
  final TransactionType type;

  TransactionDetailsController(this.type);

  var isLoading = true.obs;
  var isDownloading = false.obs; // 🔥 NEW

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

    amount.value = "€${tx.amount}";
    amount2.value = "€${tx.amount}";
    total.value = "€${tx.amount}";

    status.value = tx.status;
    dateTime.value = tx.createdAt;
    paymentMethod.value = tx.wallet;
    transactionId.value = tx.id;

    fee.value = "€${tx.fee}";

    isLoading(false);
  }

  /// ================= DOWNLOAD INVOICE =================
  Future<void> downloadInvoice() async {
    try {
      isDownloading(true);

      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.transactionInvoice}${tx.id}";
      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});

      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("PDF received: ${response.contentLength} bytes");
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/invoice_${tx.id}.pdf');
        await file.writeAsBytes(response.bodyBytes);
        
        final result = await OpenFile.open(file.path);

        if (result.type != ResultType.done) {
          print("Error opening file: ${result.message}");
          Get.snackbar(
            "Error",
            "Could not open invoice. Please make sure you have a PDF viewer installed.",
          );
        }

      } else {
        print("Response body: ${response.body}");
        Get.snackbar("Error", "Failed to download invoice. Status: ${response.statusCode}");
      }

    } catch (e) {
      print("Invoice error => $e");
      Get.snackbar("Error", "Invoice download failed");
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
