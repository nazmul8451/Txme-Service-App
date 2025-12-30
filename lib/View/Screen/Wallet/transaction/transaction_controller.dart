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
    _loadTransaction();
  }

  void _loadTransaction() async {
    isLoading(true);

    /// 🔹 Title only depends on type
    title.value = _titleFromType(type);

    /// 🔹 Rest data from API transaction
    amount.value = "€${tx.amount}";
    amount2.value = "€${tx.amount}";
    total.value = "€${tx.amount}";

    status.value = tx.status;
    dateTime.value = tx.createdAt;
    paymentMethod.value = tx.wallet;
    transactionId.value = tx.id;

    fee.value = tx.fee != null ? "€${tx.fee}" : "€0.00";

    isLoading(false);
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
