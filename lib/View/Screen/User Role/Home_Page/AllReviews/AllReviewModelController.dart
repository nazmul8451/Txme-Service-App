import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'AllReviewModel.dart';

class AllReviewModelController extends GetxController {
  final reviewList = <AllReviewModel>[].obs;
  final isLoading = false.obs;

  late String providerId;

  @override
  void onInit() {
    super.onInit();

    ///  route থেকে ID receive
    providerId = Get.arguments;

    fetchAllReviews(providerId);
  }

  Future<void> fetchAllReviews(String providerId) async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final url =
          "${ApiConstant.baseUrl}${ApiConstant.postReview}/$providerId";

      print("REVIEW API => $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['success'] == true) {
          final List data = decoded['data'];
          reviewList.value =
              data.map((e) => AllReviewModel.fromJson(e)).toList();
        } else {
          Get.snackbar("", decoded['message'] ?? "Failed");
        }
      } else {
        Get.snackbar("", "Failed to load reviews");
      }
    } catch (e) {
      Get.snackbar("", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

