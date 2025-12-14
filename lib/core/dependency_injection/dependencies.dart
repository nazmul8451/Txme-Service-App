import 'package:get/get.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/Invoice/Invoice.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaywithWallet/PaywithWalletController.dart';
import '../../View/Screen/User Role/Profile/EditProfile/EditProfileController.dart';
import '../../View/Screen/User Role/Profile/NotificationPage/NotificationController.dart';
import '../../View/Screen/User Role/Profile/VerificationPage/VerificationController.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PayWithCash/PayWithCashController.dart';

class dependencies {
  static void init() {
    Get.put(EditProfileController(), permanent: true);
    Get.put(VerificationController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(InvoicePController(), permanent: true);
    Get.put(Paywithcashcontroller(), permanent: true);
    Get.put(PayWithWalletController(), permanent: true);
  }
}