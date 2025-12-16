import 'package:get/get.dart';
import '../../View/Screen/Service Provider Role/Contactsupport/ContactSupportController.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/Invoice/Invoice.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaywithWallet/PaywithWalletController.dart';
import '../../View/Screen/User Role/Profile/EditProfile/EditProfileController.dart';
import '../../View/Screen/User Role/Profile/NotificationPage/NotificationController.dart';
import '../../View/Screen/User Role/Profile/VerificationPage/VerificationController.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PayWithCash/PayWithCashController.dart';
import '../../View/Screen/Wallet/Top_up/TopUpController.dart';
import '../../View/Screen/Wallet/WalletController.dart';

class dependencies {
  static void init() {
    Get.put(EditProfileController(), permanent: true);
    Get.put(VerificationController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(InvoicePController(), permanent: true);
    Get.put(Paywithcashcontroller(), permanent: true);
    Get.put(PayWithWalletController(), permanent: true);
    Get.put(ContactSupportController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(Topupcontroller(), permanent: true);
  }
}