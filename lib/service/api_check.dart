import 'package:get/get.dart';
import '../helper/shared_prefe/shared_prefe.dart';
import 'api_url.dart';

class ApiChecker {
  static Future<void> checkApi(Response response) async {
    if (response.statusCode == 401) {
      await SharePrefsHelper.remove(ApiConstant.bearerToken);
      // Get.offAllNamed('/login');
    }
  }
}
