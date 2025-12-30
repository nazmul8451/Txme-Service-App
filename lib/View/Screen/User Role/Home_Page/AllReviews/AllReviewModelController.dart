import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../service/api_url.dart';
import 'AllReviewModel.dart';

class AllReviewModelController extends GetxController {
  final reviewList = <AllReviewModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllReviews();
  }

  Future<void> fetchAllReviews() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.postReview),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['success'] == true) {
          final List data = decoded['data'];

          reviewList.value =
              data.map((e) => AllReviewModel.fromJson(e)).toList();
        }
      } else {
        Get.snackbar("Error", "Failed to load reviews");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
