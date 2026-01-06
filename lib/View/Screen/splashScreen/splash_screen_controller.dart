import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../core/App_Routes/app_routes.dart';
import '../../../service/api_url.dart';

class SplashController extends GetxController {
  static const String splashSeen = "splash_seen";

  @override
  void onInit() {
    super.onInit();
    _checkSplash();
  }

  Future<void> _checkSplash() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final isSplashSeen = await SharePrefsHelper.getBool(splashSeen) ?? false;
    final bearerToken = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

    if (isSplashSeen) {
      if (bearerToken != null && bearerToken.isNotEmpty) {
        // Token exists, now verify it by fetching user data.
        try {
          final res = await http.get(
            Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
            headers: {"Authorization": "Bearer $bearerToken"},
          );

          if (res.statusCode == 200) {
            // Token is valid, proceed to home pages.
            final role = await SharePrefsHelper.getString(SharePrefsHelper.userRole);
            if (role == "CUSTOMER") {
              Get.offAllNamed(AppRoute.homepage);
            } else if (role == "PROVIDER") {
              Get.offAllNamed(AppRoute.providerHomeScreen);
            } else {
              Get.offAllNamed(AppRoute.signinwithbiometrics);
            }
          } else {
            // Token is invalid/expired. Log out.
            await _logout();
          }
        } catch (e) {
          // Network error or other issue. Treat as logged out for safety.
          await _logout();
        }
      } else {
        // NOT LOGGED IN
        Get.offAllNamed(AppRoute.signinwithbiometrics);
      }
    } else {
      // FIRST TIME USER
      // Stay on splash screen / show get started page
    }
  }

  Future<void> _logout() async {
    await SharePrefsHelper.remove(SharePrefsHelper.bearerToken);
    await SharePrefsHelper.remove(SharePrefsHelper.userRole);
    Get.offAllNamed(AppRoute.signinwithbiometrics);
  }

  Future<void> onGetStarted() async {
    await SharePrefsHelper.setBool(splashSeen, true);
    Get.offAllNamed(AppRoute.signinwithbiometrics);
  }
}
