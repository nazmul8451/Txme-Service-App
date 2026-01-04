import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/socket_service.dart';
import '../model/chat_model.dart';

class ChatController extends GetxController {
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final SocketApi socketApi = Get.find<SocketApi>();

  String? myUserId;

  List<ChatModel> get filteredChats {
    if (searchQuery.isEmpty) {
      return chats;
    }
    return chats
        .where((chat) =>
            chat.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() async {
    super.onInit();
    myUserId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    getChats();

    socketApi.on('getChat', (data) {
      if (myUserId != null) {
        final updatedChat = ChatModel.fromJson(data, myUserId!);
        chats.removeWhere((chat) => chat.id == updatedChat.id);
        chats.insert(0, updatedChat);
      }
    });
  }

  Future<void> getChats() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.getChat}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (myUserId != null) {
          final chatList = (data['data'] as List)
              .map((chatJson) => ChatModel.fromJson(chatJson, myUserId!))
              .toList();
          chats.assignAll(chatList);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch chats");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  void updateLastMessage(String chatId, String message) {
    final index = chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final chat = chats.removeAt(index);
      final updatedChat = chat.copyWith(lastMessage: message);
      chats.insert(0, updatedChat);
    }
  }
}
