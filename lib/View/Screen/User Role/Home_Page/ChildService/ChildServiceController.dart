import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../service/api_url.dart';
import 'ChildServiceModel.dart';

class ChildServiceController extends GetxController {
  final String parentId;

  ChildServiceController(this.parentId);

  final isLoading = false.obs;
  final childServices = <ChildServiceModel>[].obs;

  Future<void> getChildServices() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}${ApiConstant.serviceGet}?parent=$parentId",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"]["services"];

        childServices.value =
            list.map((e) => ChildServiceModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Child service error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    getChildServices();
    super.onInit();
  }
}
