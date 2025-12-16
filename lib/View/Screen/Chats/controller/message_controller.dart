

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/message_model.dart';

class MessageController extends GetxController {
  final String chatId;

  MessageController(this.chatId);

  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages();
    // connectSocket(chatId); // later
  }

  void loadInitialMessages() {
    messages.value = [
      MessageModel(
        id: "1",
        message: "Hello ",
        isMe: false,
        time: "10:00 AM",
      ),
      MessageModel(
        id: "2",
        message: "Hi, how are you?",
        isMe: true,
        time: "10:01 AM",
      ),
    ];
  }

  /// Send message (API / Socket)
  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final msg = MessageModel(
      id: DateTime.now().toString(),
      message: messageController.text,
      isMe: true,
      time: "Now",
    );

    messages.add(msg);

    /// socket.emit("send_message", msg);
    messageController.clear();
  }

  /// Receive from socket
  void onReceiveMessage(Map<String, dynamic> data) {
    messages.add(MessageModel.fromJson(data));
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
