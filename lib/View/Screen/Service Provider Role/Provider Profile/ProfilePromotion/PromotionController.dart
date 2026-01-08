import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:txme_app/helper/Shared_prefe/shared_prefe.dart';
import 'package:txme_app/service/api_url.dart';
import 'PromotionPackageModel.dart';

class PromotionController extends GetxController {
  var isLoading = true.obs;
  var packages = <PromotionPackageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.profilePromotion}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        packages.value = data.map((json) => PromotionPackageModel.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to load promotion packages.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred.");
    } finally {
      isLoading.value = false;
    }
  }

  // PromotionController.dart তে যোগ করুন
  void activatePackage(String packageId) {
    // TODO: API call to activate package
    Get.snackbar(
      "Package Selected",
      "Activating package...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    // Here you'll call your payment/activation API
  }

}
