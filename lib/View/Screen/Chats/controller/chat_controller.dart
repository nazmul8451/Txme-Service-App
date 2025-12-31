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
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  /// 🔍 SEARCH
  RxString searchQuery = "".obs;

  RxBool isLoading = false.obs;

  final SocketApi socketApi = SocketApi();
  late String myUserId;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    myUserId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    await getChats();
    initSocket();
  }


  StreamSubscription? _socketSubscription;

  void initSocket() async {
    await socketApi.init();
    
    // Ensure userId is loaded before listening
    if (myUserId.isEmpty) {
      myUserId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    }

    final eventName = "chatListUpdate::$myUserId";
    debugPrint("🎧 Listening to Chat List Event: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📩 CHAT LIST UPDATE RAW DATA: $data");

      if (data == null) return;

      try {
        final raw = data['message'] ?? data;
        
        // Handle different data structures
        final chatId = raw['chatId'] ?? raw['room'] ?? data['chatId'];
        
        if (chatId == null) {
          debugPrint("❌ Chat List Update: ChatId is null");
          return;
        }

        final index = chatList.indexWhere((c) => c.id == chatId);

        // If chat exists, update it
        if (index != -1) {
          final msgText = raw['text'] ?? raw['lastMessage'] ?? 'Message';
          final createdAt = raw['createdAt'] ?? DateTime.now().toString();
          
          // Try to get sender info if available
          final sender = raw['sender'];
          String? newName;
          String? newAvatar;

          if (sender is Map) {
             // If sender is NOT me, it might be the other user
             if (sender['_id'] != myUserId) {
                // We typically don't change the chat name/avatar based on a message unless it's a group
                // But if it's 1-on-1, the name/avatar is fixed to the other person.
                // So we actually don't need to update name/avatar usually.
             }
          }

          final old = chatList[index];
          
          // Move to top
          chatList.removeAt(index);
          
          chatList.insert(0, old.copyWith(
            lastMessage: msgText,
            time: createdAt, 
            unreadCount: old.unreadCount + 1,
            // Keep old name/avatar unless explicitly changed
          ));
          debugPrint("✅ Updated Chat $chatId moved to top");
        } else {
             // Refresh list if new chat
             debugPrint("🆕 New Chat detected, refreshing list...");
             getChats(); 
        }
      } catch (e) {
        print("ChatController Socket Error: $e");
      }
    });
  }

  @override
  void onClose() {
    if (myUserId.isNotEmpty) {
      socketApi.off("chatListUpdate::$myUserId");
    }
    super.onClose();
  }

  //get chat funcfion
  

  Future<void> getChats() async {
    try {
      isLoading.value = true;

      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final response = await http.get(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.getChat}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        chatList.value = (decoded['data'] as List)
            .map((e) => ChatModel.fromJson(e, myUserId))
            .toList();
        update();
      }
              update();

    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ THIS IS WHAT YOUR UI NEEDS
  List<ChatModel> get filteredChats {
    if (searchQuery.value.isEmpty) {
      return chatList;
    }

    return chatList
        .where((c) =>
        c.name.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ))
        .toList();
  }

  /// 🔄 Call this from MessageController when sending a message
  void updateLastMessage(String chatId, String message) {
    final index = chatList.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final old = chatList[index];
      chatList.removeAt(index);
      chatList.insert(0, old.copyWith(
        lastMessage: message,
        time: "Now", // Or handle actual time
      ));
      update();
    }
  }
}




