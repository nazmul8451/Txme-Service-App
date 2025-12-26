

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../models/provider_model.dart';

class ProviderController extends GetxController {
  RxList<ProviderModel> providers = <ProviderModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> getAllProviders() async {
    isLoading.value = true;

    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.allProviderUser}"),
      headers: {
        "Authorization":
        "Bearer ${await SharePrefsHelper.getString(ApiConstant.bearerToken)}",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded['data']['data'];

      providers.value = list
          .map<ProviderModel>((e) => ProviderModel.fromJson(e))
          .toList();
    }

    isLoading.value = false;
  }
}
