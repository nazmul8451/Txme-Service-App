import 'package:get/get.dart';
import '../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../core/App_Routes/app_routes.dart';

class SplashController extends GetxController {
  static const String splashSeen = "splash_seen";

  @override
  void onInit() {
    super.onInit();
    _checkSplash();
  }

  /// 🔍 CHECK SPLASH (only once)
  Future<void> _checkSplash() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final isSplashSeen =
    await SharePrefsHelper.getBool(splashSeen);

    final refreshToken =
    await SharePrefsHelper.getString(SharePrefsHelper.refreshToken);

    /// ✅ SPLASH ALREADY SEEN
    if (isSplashSeen) {

      /// 🔐 USER LOGGED IN (refresh token exists)
      if (refreshToken.isNotEmpty) {
        Get.offAllNamed(AppRoute.homepage);
      }
      /// 🚪 NOT LOGGED IN
      else {
        Get.offAllNamed(AppRoute.signinwithbiometrics);
      }
    }

    ///  splashSeen == false হলে
    /// UI তেই থাকবে → Get Started দেখাবে
  }

  /// 👉 GET STARTED BUTTON
  Future<void> onGetStarted() async {
    await SharePrefsHelper.setBool(splashSeen, true);
    Get.offAllNamed(AppRoute.signinwithbiometrics);
  }
}
