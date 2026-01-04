import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../service/api_url.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../Chats/model/chat_model.dart';
import '../../../Chats/view/chat_details_page.dart';
import '../AllReviews/AllReviewModel.dart';
import '../models/provider_stats_model.dart';

class Providersdetailscontroller extends GetxController {
  final isUserSelected = true.obs;
  final isLoading = false.obs;
  final reviewList = <AllReviewModel>[].obs;
  final providerStats = Rx<ProviderStats?>(null);

  void selectRequest() {
    print("🔹 selectRequest() called");
    isUserSelected.value = true;
  }

  Future<void> selectMessage({
    required String participantId,
  }) async {
    print("🟢 selectMessage() called");
    print("👤 participantId => $participantId");

    isUserSelected.value = false;
    await _createChat(participantId);
  }

  Future<void> _createChat(String participantId) async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

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

  Future<void> fetchAllReviews(String providerId) async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final response = await http.get(
        Uri.parse(
          "${ApiConstant.baseUrl}${ApiConstant.postReview}/$providerId",
        ),

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

  Future<void> fetchProviderStats(String providerId) async {
    try {
      final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);
      // ✅ UPDATED: Use the new ApiConstant
      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.providerStats}$providerId/statistics"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          providerStats.value = ProviderStats.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      print("Error fetching provider stats: $e");
    }
  }
}
