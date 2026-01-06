import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';
import '../../../Chats/model/chat_model.dart';
import '../../../Chats/view/chat_details_page.dart';

class ContactSupportController extends GetxController {
  final isLoading = false.obs;

  Future<void> createAdminChat() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.chatAdminSupport}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        final myUserId = await SharePrefsHelper.getString("userId") ?? '';

        final chat = ChatModel.fromJson(decoded['data'], myUserId);
        
        Get.to(() => ChatDetailsPage(chat: chat));

      } else {
        final errorBody = json.decode(response.body);
        Get.snackbar("Could not start chat", errorBody['message'] ?? "Please try again later.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
    } finally {
      isLoading.value = false;
    }
  }
}
