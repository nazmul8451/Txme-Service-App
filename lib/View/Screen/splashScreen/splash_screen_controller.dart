import 'package:get/get.dart';
import '../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../core/App_Routes/app_routes.dart';

class SplashController extends GetxController {
  static const String splashSeen = "splash_seen";

  @override
  void onInit() {
    super.onInit();
    _checkSplash(); // 🔥 FIX
  }

  Future<void> _checkSplash() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final isSplashSeen =
        await SharePrefsHelper.getBool(splashSeen) ?? false;

    final bearerToken =
    await SharePrefsHelper.getString(
      SharePrefsHelper.bearerToken,
    );

    final role =
    await SharePrefsHelper.getString(
      SharePrefsHelper.userRole,
    );

    /// SPLASH SEEN
    if (isSplashSeen) {
      /// USER LOGGED IN
      if (bearerToken.isNotEmpty) {
        if (role == "CUSTOMER") {
          Get.offAllNamed(AppRoute.homepage);
        } else if (role == "PROVIDER") {
          Get.offAllNamed(AppRoute.providerHomeScreen);
        } else {
          Get.offAllNamed(AppRoute.signinwithbiometrics);
        }
      } else {
        /// NOT LOGGED IN
        Get.offAllNamed(AppRoute.signinwithbiometrics);
      }
    } else {
      /// FIRST TIME USER
      // splash screen e thakbe / get started দেখাবে
    }
  }

  /// GET STARTED
  Future<void> onGetStarted() async {
    await SharePrefsHelper.setBool(splashSeen, true);
    Get.offAllNamed(AppRoute.signinwithbiometrics);
  }
}
