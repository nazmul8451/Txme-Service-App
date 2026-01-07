import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../../../service/socket_service.dart';
import 'notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var isMoreLoading = false.obs; // ✅ ADDED: For pagination loading
  var notificationList = <NotificationModel>[].obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 10;
  
  final SocketApi socketApi = Get.find<SocketApi>();
  String? _eventName;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(page: 1);
    _initSocket();
  }

  Future<void> _initSocket() async {
    final userId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    if (userId.isEmpty) return;

    _eventName = "notification::$userId";
    socketApi.on(_eventName!, (data) {
      print("🔔 Notification received: $data");
      refreshNotifications();
    });
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications(page: 1);
  }

  Future<void> fetchNotifications({required int page}) async {
    // ✅ UPDATED: Use isMoreLoading for subsequent pages
    if (page == 1) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

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

        if (page == 1) {
          notificationList.assignAll(newNotifications);
        } else {
          notificationList.addAll(newNotifications);
        }

        if (data['data']['pagination'] != null) {
          totalPages.value = data['data']['pagination']['totalPage'] ?? 1;
          currentPage.value = data['data']['pagination']['page'] ?? 1;
        }

      } else {
        // Handle error if needed
      }
    } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar('An error occurred', e.toString());
      });
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false; //  ADDED: Always set to false
    }
  }

  void loadNextPage() {
    if (currentPage.value < totalPages.value && !isMoreLoading.value) {
      fetchNotifications(page: currentPage.value + 1);
    }
  }

  void loadPreviousPage() {
    if (currentPage.value > 1 && !isMoreLoading.value) {
      fetchNotifications(page: currentPage.value - 1);
    }
  }
  
  @override
  void onClose() {
    if (_eventName != null) {
      socketApi.off(_eventName!);
    }
    super.onClose();
  }
}
