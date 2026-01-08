import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import '../core/App_Routes/app_routes.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  void init() async {
    // App closed অবস্থায় open হলে
    final Uri? initialUri = await _appLinks.getInitialAppLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // App running / background অবস্থায়
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleUri(uri);
      }
    });
  }

  void _handleUri(Uri uri) {
    print("🔗 DEEP LINK RECEIVED => $uri");

    if (uri.scheme == 'txme' && uri.host == 'app') {
      if (uri.path == '/kyc-status') {
        final result = uri.queryParameters['result'];

        if (result == 'success') {
          // ✅ KYC success
          Get.offAllNamed(AppRoute.createaccount);
        } else if (result == 'failed') {
          // ❌ KYC failed
          Get.offAllNamed(AppRoute.verifyFailed);
        }
      }
    }
  }

}
