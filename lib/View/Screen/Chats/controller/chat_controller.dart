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
    myUserId = await SharePrefsHelper.getString("userId");
    await getChats();
    initSocket();
  }


  StreamSubscription? _socketSubscription;

  void initSocket() async {
    await socketApi.init();
    
    // Ensure userId is loaded before listening
    if (myUserId.isEmpty) {
      myUserId = await SharePrefsHelper.getString("userId");
    }

    final eventName = "chatListUpdate::$myUserId";
    debugPrint("🎧 Listening to Chat List Event: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📩 CHAT LIST UPDATE: $data");

      if (data == null) return;
      
      try {
        final chatId = data['chatId'];
        // It might be nested in 'data'
        final finalChatId = chatId ?? data['data']?['chatId'];
        
        if (finalChatId == null) return;
        
        final index = chatList.indexWhere((c) => c.id == finalChatId);
        
        // If chat exists, update it
        if (index != -1) {
          final raw = data['message'] ?? data;
          final msgText = raw['text'] ?? 'Message';
          
          // Try to get sender info if available
          final sender = raw['sender'];
          String? newName;
          String? newAvatar;
          
          if (sender is Map) {
             // Only update if it's the OTHER user
             if (sender['_id'] != myUserId) {
                newName = sender['fullName'];
                newAvatar = sender['avatar'];
             }
          } else if (sender is String) {
            // Sender is just an ID
          }
          
          final old = chatList[index];
          
          // Move to top
          chatList.removeAt(index);
          chatList.insert(0, old.copyWith(
            lastMessage: msgText,
            time: "Now",
            unreadCount: old.unreadCount + 1,
            name: newName,
            avatar: newAvatar,
          ));
        } else {
             // Refresh list if new chat
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
}




