import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../../service/api_url.dart';
import '../../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../Chats/model/chat_model.dart';
import '../../../Chats/view/chat_details_page.dart';

class ProviderProfileDetailsController extends GetxController {
  final isUserSelected = true.obs;
  final isLoading = false.obs;

  void selectRequest() {
    isUserSelected.value = true;
  }

  Future<void> selectMessage({
    required String participantId,
  }) async {
    isUserSelected.value = false;
    await _createChat(participantId);
  }

  Future<void> _createChat(String participantId) async {
    try {
      isLoading.value = true;

      final token = await SharePrefsHelper.getString(
        SharePrefsHelper.bearerToken,
      );

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.CeatsChat}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "participant": participantId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final myUserId =
        await SharePrefsHelper.getString("userId");

        final chat = ChatModel.fromJson(
          decoded['data'],
          myUserId,
        );

        Get.to(() => ChatDetailsPage(chat: chat));
      } else {
        Get.snackbar("Error", "Chat create failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

