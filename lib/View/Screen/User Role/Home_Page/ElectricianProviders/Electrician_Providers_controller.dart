

import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../models/provider_model.dart';

class ProviderController extends GetxController {
  RxList<ProviderModel> providers = <ProviderModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;

  int page = 1;
  final int limit = 10;
  int totalPage = 1;

  @override
  void onInit() {
    super.onInit();
    getAllProviders(isFirst: true);
  }

  Future<void> getAllProviders({bool isFirst = false}) async {
    try {
      if (isFirst) {
        page = 1;
        providers.clear();
        isLoading(true);
      } else {
        if (page >= totalPage) return;
        page++;
        isMoreLoading(true);
      }

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final url =
          "${ApiConstant.baseUrl}${ApiConstant.allProviderUser}?page=$page&limit=$limit";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List list = decoded['data']['data'];
        final meta = decoded['data']['meta'];

        totalPage = meta['totalPage'] ?? 1;

        final newProviders =
        list.map((e) => ProviderModel.fromJson(e)).toList();

        providers.addAll(newProviders);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }
}

