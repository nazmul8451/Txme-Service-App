import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../service/api_url.dart';
import 'ServiceModel.dart';

class ServiceController extends GetxController {
  final isLoading = false.obs;
  final parentServices = <ServiceModel>[].obs;

  Future<void> getParentServices() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}${ApiConstant.serviceGet}",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"]["services"];

        parentServices.value = list
            .where((e) => e["parent"] == null) // parent only
            .map((e) => ServiceModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Service error: $e");
    } finally {
      isLoading.value = false;
    }

    Future<void> refresh() async {
      await getParentServices();
    }
  }



  @override
  void onInit() {
    getParentServices();
    super.onInit();
  }

  List<ServiceModel> get homeServices =>
      parentServices.take(6).toList();


}
