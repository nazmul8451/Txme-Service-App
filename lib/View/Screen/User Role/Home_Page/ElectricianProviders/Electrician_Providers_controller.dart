import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Map<String, String> filterParams = {};

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map<String, String>) {
      filterParams = Get.arguments;
    }
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

      final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        ...filterParams,
      };

      queryParameters.removeWhere((key, value) => value.isEmpty);

      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.allProviderUser}")
          .replace(queryParameters: queryParameters);

      debugPrint("✅ Fetching providers with URL: $uri");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded['data'] ?? [];
        final pagination = decoded['pagination'];

        totalPage = pagination?['totalPage'] ?? 1;

        final newProviders =
            list.map((e) => ProviderModel.fromJson(e)).toList();

        providers.addAll(newProviders);
      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar("", errorBody['message'] ?? "Failed to load providers");
      }
    } catch (e) {
      Get.snackbar("", e.toString());
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }
}
