import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final response = await http.get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.notification),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> notificationsJson = data['data']['notifications'];
        notificationList.value = notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch notifications');
        print('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      print('Error fetching notifications: $e');
    } finally {
      isLoading(false);
    }
  }
}
