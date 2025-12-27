
import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  final isMoreLoading = false.obs;
  final providers = <PopularProviderModel>[].obs;

  int page = 1;
  final int limit = 10;
  int totalPage = 1;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🔥 PopularProviderController onInit CALLED");
    fetchPopularProviders(isFirst: true);
  }

  Future<void> fetchPopularProviders({bool isFirst = false}) async {
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
      await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final url =
          "${ApiConstant.baseUrl}${ApiConstant.popularProviders}?page=$page&limit=$limit";

      debugPrint("🚀 API HIT 👉 $url");

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        final List list = decoded['data']?['data'] ?? [];
        final meta = decoded['data']?['meta'];

        totalPage = meta?['totalPage'] ?? 1;

        final newProviders =
        list.map((e) => PopularProviderModel.fromJson(e)).toList();

        providers.addAll(newProviders);

        debugPrint(
            "✅ PAGE $page / $totalPage | TOTAL LOADED 👉 ${providers.length}");
      }
    } catch (e) {
      debugPrint("❌ ERROR 👉 $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }
}

