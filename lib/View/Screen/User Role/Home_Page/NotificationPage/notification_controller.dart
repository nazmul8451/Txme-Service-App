import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import 'notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var notificationList = <NotificationModel>[].obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 10;

  @override
  void onInit() {
    fetchNotifications(page: 1);
    super.onInit();
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications(page: 1);
  }

  Future<void> fetchNotifications({required int page}) async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.notification}?page=$page&limit=$limit";
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> notificationsJson = data['data']['notifications'];
        final newNotifications = notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();

        notificationList.assignAll(newNotifications);

        if (data['data']['pagination'] != null) {
          totalPages.value = data['data']['pagination']['totalPage'] ?? 1;
          currentPage.value = data['data']['pagination']['page'] ?? 1;
        }

      } else {
        Get.snackbar('Error', 'Failed to fetch notifications');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (currentPage.value < totalPages.value) {
      fetchNotifications(page: currentPage.value + 1);
    }
  }

  void loadPreviousPage() {
    if (currentPage.value > 1) {
      fetchNotifications(page: currentPage.value - 1);
    }
  }
}
