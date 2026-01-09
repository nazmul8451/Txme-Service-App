import 'package:get/get.dart';
import '../../View/Screen/Service Provider Role/MyBooking/ConfirmPayment/ConfirmPaymentController.dart';
import '../../View/Screen/Sign _up/VerifyYourIdentity/verify_identity_controller.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/Invoice/Invoice.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PaywithWallet/PaywithWalletController.dart';
import '../../View/Screen/User Role/Home_Page/NotificationPage/notification_controller.dart';
import '../../View/Screen/User Role/Home_Page/Popularservices/ServiceController.dart';
import '../../View/Screen/User Role/Profile/EditProfile/EditProfileController.dart';
import '../../View/Screen/User Role/Profile/NotificationPage/SettingsController.dart';
import '../../View/Screen/User Role/Profile/VerificationPage/VerificationController.dart';
import '../../View/Screen/User Role/BookingsViewClient/Payment/PayWithCash/PayWithCashController.dart';
import '../../View/Screen/Wallet/Availablebalance/WalletController.dart';
import '../../View/Screen/Wallet/Top_up/TopUpController.dart';
import '../../View/Screen/Wallet/WalletController.dart';
import '../../View/Screen/splashScreen/splash_screen_controller.dart';
import '../../View/Widgegt/JobProgressTime/JobTimerController.dart';
/// ⏱️ GLOBAL TIMER CONTROLLER


class Dependencies {
  static void init() {
    /// ================= CORE =================
    Get.put(SplashController(), permanent: true);

    /// ================= PROFILE =================
    Get.put(EditProfileController(), permanent: true);
    Get.put(VerificationController(), permanent: true);
    Get.put(VerifyIdentityController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(SettingsController(), permanent: true);

    /// ================= WALLET =================
    Get.put(WalletController(), permanent: true);
    Get.put(WalletControllerA(), permanent: true);
    Get.put(Topupcontroller(), permanent: true);

    /// ================= PAYMENT =================
    Get.put(InvoicePController(), permanent: true);
    Get.put(Paywithcashcontroller(), permanent: true);
    Get.put(PayWithWalletController(), permanent: true);



    /// ================= SERVICES =================
    Get.put(ServiceController(), permanent: true);

    /// ================= ⏱️ GLOBAL ELAPSED TIMER =================
    Get.put(JobTimerController(), permanent: true);
    Get.put(Confirmpaymentcontroller(), permanent: true);
  }
}
