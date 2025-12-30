import 'package:get/get.dart';
import '../WalletTransaction.dart';
import 'transaction_type.dart';

class TransactionDetailsController extends GetxController {

  final WalletTransaction tx = Get.arguments as WalletTransaction;

  final TransactionType type;

  TransactionDetailsController(this.type);

  var isLoading = true.obs;

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
    loadTransaction();
  }

  void loadTransaction() async {
    isLoading.value = true;

    switch (type) {
      case TransactionType.topUp:
        await topUpApi();
        break;
      case TransactionType.withdraw:
        await withdrawApi();
        break;
      case TransactionType.send:
        await sendApi();
        break;
      case TransactionType.receive:
        await receiveApi();
        break;
    }

    isLoading.value = false;
  }

  // 🔹 Dummy APIs (এখানে real API বসাবে)
  Future<void> topUpApi() async {
    await Future.delayed(const Duration(seconds: 1));
    title.value = "Top-Up";
    amount.value = "€50.00";
    status.value = "Successful";
    dateTime.value = "Oct 26, 2025 | 10:34 AM";
    paymentMethod.value = "Visa ****12345";
    transactionId.value = "TXN_TOPUP_001";
    amount2.value = "€50.00";
    fee.value = "€00.00:";
    total.value = "€50.00";
  }

  Future<void> withdrawApi() async {
    await Future.delayed(const Duration(seconds: 1));
    title.value = "Withdraw";
    amount.value = "€50.00";
    status.value = "Successful";
    dateTime.value = "Oct 26, 2025 | 10:34 AM";
    paymentMethod.value = "Visa ****67890";
    transactionId.value = "TXN_WITHDRAW_002";
    amount2.value = "€50.00";
    fee.value = "€00.00:";
    total.value = "€50.00";
  }

  Future<void> sendApi() async {
    await Future.delayed(const Duration(milliseconds: 500));
    title.value = tx.type;
    amount.value = "€${tx.amount}";
    status.value = tx.status;
    dateTime.value = tx.createdAt;
    paymentMethod.value = tx.wallet;
    transactionId.value = tx.id;
    amount2.value = "€${tx.amount}";
    fee.value =  "€0.00";
    total.value = "€${tx.amount}";
  }

  Future<void> receiveApi() async {
    await Future.delayed(const Duration(seconds: 1));
    title.value = "Receive";
    amount.value = "€50.00";
    status.value = "Successful";
    dateTime.value = "Oct 26, 2025 | 10:34 AM";
    paymentMethod.value = "Wallet";
    transactionId.value = "TXN_RECEIVE_004";
    amount2.value = "€50.00";
    fee.value = "€00.00:";
    total.value = "€50.00";
  }
}
