import 'package:get/get.dart';
import '../../../helper/shared_prefe/shared_prefe.dart';
import '../../../core/App_Routes/app_routes.dart';

class SplashController extends GetxController {
  static const String _getStartedKey = "isGetStartedClicked";
  static const String _refreshTokenKey = "refresh_token";

  @override
  void onInit() {
    super.onInit();
    _handleSplashLogic();
  }

  /// ================= SPLASH LOGIC =================
  Future<void> _handleSplashLogic() async {
    final isGetStarted =
    await SharePrefsHelper.getString(_getStartedKey);

    final refreshToken =
    await SharePrefsHelper.getString(_refreshTokenKey);

    // small delay for splash UX
    await Future.delayed(const Duration(milliseconds: 800));

    ///  USER ALREADY LOGGED IN
    if (refreshToken.isNotEmpty) {
      Get.offAllNamed(AppRoute.homepage);
      return;
    }

    ///  FIRST TIME / NOT LOGGED IN USER
    if (isGetStarted == "true") {
      Get.offAllNamed(AppRoute.languagepage);
    }
  }

  /// ================= GET STARTED =================
  Future<void> onGetStarted() async {
    await SharePrefsHelper.setString(_getStartedKey, "true");
    Get.offAllNamed(AppRoute.languagepage);
  }
}
