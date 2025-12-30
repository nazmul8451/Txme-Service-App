import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/socket_service.dart';
import '../model/message_model.dart';

class MessageController extends GetxController {
  final String chatId;
  MessageController(this.chatId);

  StreamSubscription? _socketSubscription;

  /// ✅ GLOBAL SOCKET INSTANCE
  final SocketApi socketApi = SocketApi();

  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  late String myUserId;

  @override
  void onInit() {
    super.onInit();
    // No change needed here really, just ensuring structure is essentially correct
    _init(); // _init is async and handles loading user ID first
  }

  Future<void> _init() async {
    myUserId = await SharePrefsHelper.getString("userId");

    /// 🔥 JOIN CHAT ROOM
    socketApi.joinChat(chatId);

    /// 🔥 LOAD OLD MESSAGES
    await getMessages();

    /// 🔥 LISTEN SOCKET MESSAGE
    final eventName = "getMessage::$chatId";
    
    debugPrint("🎧 Listening to Socket Event: $eventName");
    
    socketApi.on(eventName, (data) {
      debugPrint("📩 EVENT RECEIVED [$eventName]: $data");
      
      final raw = data['message'] ?? data;

      try {
        final msg = MessageModel.fromJson(raw, myUserId);

        // Avoid duplicates if we already have this message ID
        if (messages.any((m) => m.id == msg.id)) return;

        messages.add(msg);
        
      } catch (e) {
        debugPrint("Message Parse Error: $e");
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

      messages.value = list
          .map<MessageModel>((e) => MessageModel.fromJson(e, myUserId))
          .toList();
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
    messages.add(
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
