import 'dart:async';
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
  Timer? _debounce;

  List<ChatModel> get filteredChats {
    // This getter is no longer needed for filtering, as the API handles it.
    // However, it can be kept for consistency if other parts of the app use it.
    return chats;
  }

  @override
  void onInit() async {
    super.onInit();
    myUserId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    getChats();

    // ✅ ADDED: Debouncer for search query
    debounce(searchQuery, (_) => getChats(searchTerm: searchQuery.value), time: const Duration(milliseconds: 500));

    socketApi.on('getChat', (data) {
      if (myUserId != null) {
        final updatedChat = ChatModel.fromJson(data, myUserId!);
        chats.removeWhere((chat) => chat.id == updatedChat.id);
        chats.insert(0, updatedChat);
      }
    });
  }

  Future<void> getChats({String? searchTerm}) async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);

      // ✅ UPDATED: Build URI with search term
      final uri = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.getChat}").replace(
        queryParameters: {
          if (searchTerm != null && searchTerm.isNotEmpty) 'searchTerm': searchTerm,
          'limit': '200', // As per your Postman screenshot
        },
      );
      
      debugPrint("🚀 Fetching chats with URL: $uri");

      final response = await http.get(
        uri,
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
        Get.snackbar("Failed to fetch chats", "");
      }
    } catch (e) {
      Get.snackbar(e.toString(), "");
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

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
