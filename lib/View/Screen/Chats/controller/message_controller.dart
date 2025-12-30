import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/socket_service.dart';
import '../model/message_model.dart';
import 'chat_controller.dart';

class MessageController extends GetxController {
  final String chatId;
  MessageController(this.chatId);

  StreamSubscription? _socketSubscription;

  /// ✅ GLOBAL SOCKET INSTANCE
  final SocketApi socketApi = SocketApi();

  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  /// Header Info
  RxString chatName = "".obs;
  RxString chatAvatar = "".obs;

  late String myUserId;

  @override
  void onInit() {
    super.onInit();
    // No change needed here really, just ensuring structure is essentially correct
    _init(); // _init is async and handles loading user ID first
  }

  Future<void> _init() async {
    // Ensure userId is fetched
    final fetchedId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    myUserId = fetchedId;
    debugPrint("👤 My User ID loaded: $myUserId");

    if (myUserId.isEmpty) {
      debugPrint("❌ ERROR: User ID is empty! Cannot determine 'isMe'.");
    }

    /// 🔥 JOIN CHAT ROOM
    socketApi.joinChat(chatId);

    /// 🔥 LOAD OLD MESSAGES
    await getMessages();

    /// 🔥 LISTEN SOCKET MESSAGE
    final eventName = "getMessage::$chatId";
    
    debugPrint("🎧 Listening to Socket Event: $eventName");
    
    socketApi.on(eventName, (data) {
      debugPrint("📩 EVENT RECEIVED [$eventName]: $data");
      
      if (data == null) return;

      final raw = data['message'] ?? data;

      try {
        final msg = MessageModel.fromJson(raw, myUserId);
        debugPrint("🧩 Parsed Socket Message: ${msg.message} | isMe: ${msg.isMe}");

        // ✅ Check if this message mimics my own optimistic message
        if (messages.any((m) => m.id == msg.id)) {
           debugPrint("⚠️ Duplicate Message ID ignored: ${msg.id}");
           return;
        }
        
        if (msg.isMe) {
           // Check for temp message match
           final tempIndex = messages.indexWhere((m) => m.id.startsWith("temp_") && m.message == msg.message);
           
           if (tempIndex != -1) {
             debugPrint("🔄 Replacing Temp Message with Socket Message");
             messages[tempIndex] = msg;
             return; 
           }
        }
        
        messages.insert(0, msg);
        
      } catch (e) {
        debugPrint("❌ Message Parse Error: $e");
      }
    });

  }

  /// ================= GET OLD MESSAGES =================
  Future<void> getMessages() async {
    final token =
    await SharePrefsHelper.getString(ApiConstant.bearerToken);

    final response = await http.get(
      Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.apiVersion}/message/$chatId?page=1&limit=50",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final list = decoded['data'] is Map
          ? decoded['data']['messages']
          : decoded['data'];

      // ✅ Parse Participant info if available to update Header
      if (decoded['data'] is Map && decoded['data']['participant'] != null) {
          final p = decoded['data']['participant'];
          chatName.value = p['fullName'] ?? chatName.value;
          chatAvatar.value = p['profilePicture'] ?? p['avatar'] ?? chatAvatar.value;
      }

      messages.value = list
          .map<MessageModel>((e) => MessageModel.fromJson(e, myUserId))
          .toList()
          .reversed
          .toList(); // Reverse so Index 0 is Newest (Bottom)
      update();
    }
  }

  /// ================= SEND MESSAGE =================
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    /// 🔥 TEMP ID (IMPORTANT)
    final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";

    /// ✅ 1. OPTIMISTIC UI
    messages.insert(0,
      MessageModel(
        id: tempId,
        message: text,
        isMe: true,
        time: "now",
      ),
    );
    update();

    messageController.clear();

    /// ✅ 2. SOCKET → REALTIME
    socketApi.sendMessage(
      chatId: chatId,
      text: text,
    );

    /// 🔄 Update Chat List Screen (Last Message)
    try {
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().updateLastMessage(chatId, text);
      }
    } catch (e) {
      debugPrint("Error updating Chat List: $e");
    }

    /// ✅ 3. API → SAVE DATABASE
    try {
      final token =
      await SharePrefsHelper.getString(ApiConstant.bearerToken);

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.message}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "chatId": chatId,
          "text": text,
          "type": "TEXT",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final savedMsg =
        MessageModel.fromJson(decoded['data'], myUserId);

        ///  REPLACE TEMP MESSAGE WITH REAL ONE
        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = savedMsg;
          update();
        }
      } else {
        debugPrint("❌ Message save failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Message API error: $e");
    }
  }

  @override
  void onClose() {
    socketApi.off("getMessage::$chatId");
    socketApi.leaveChat(chatId);
    messageController.dispose();
    update();
    super.onClose();
  }
}
