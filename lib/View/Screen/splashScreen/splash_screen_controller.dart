import 'package:get/get.dart';
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import '../../../core/App_Routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    final splashSeen =
    await SharePrefsHelper.getBool(SharePrefsHelper.splashSeen);
    final languageSelected =
    await SharePrefsHelper.getBool(SharePrefsHelper.languageSelected);

    /// 👉 Splash already seen
    if (splashSeen) {
      /// 👉 Language also selected → skip both
      if (languageSelected) {
        Get.offAllNamed(AppRoute.signAsScreen);
      } else {
        Get.offAllNamed(AppRoute.languagepage);
      }
    }
  }

  /// Get Started button
  Future<void> onGetStarted() async {
    await SharePrefsHelper.setBool(
        SharePrefsHelper.splashSeen, true);

    Get.offAllNamed(AppRoute.languagepage);
  }
}

