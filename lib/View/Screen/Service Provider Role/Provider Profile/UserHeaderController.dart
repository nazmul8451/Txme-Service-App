import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Model/UserModel.dart';
import 'UserHeaderModel.dart';


class UserHeaderController extends GetxController {
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  Future<void> fetchUserHeader() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.userMe),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        user.value = UserModel.fromJson(decoded['data']);
      } else {
        Get.snackbar("Error", "Failed to load profile");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserHeader();
  }
}
