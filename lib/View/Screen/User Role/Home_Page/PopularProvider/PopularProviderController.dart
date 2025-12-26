
import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'Model/PopularProviderModel.dart';

class PopularProviderController extends GetxController {
  final isLoading = false.obs;
  final providers = <PopularProviderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularProviders();
  }

  ///  HOME PAGE → ONLY 2 PROVIDERS
  List<PopularProviderModel> get homeProviders {
    if (providers.length > 2) {
      return providers.take(2).toList();
    }
    return providers;
  }

  Future<void> fetchPopularProviders() async {
    try {
      isLoading(true);

      final token =
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final res = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.popularProviders),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List list = decoded['data'];

        providers.assignAll(
          list.map((e) => PopularProviderModel.fromJson(e)).toList(),
        );
      } else {
        Get.snackbar("Error", "Failed to load providers");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

