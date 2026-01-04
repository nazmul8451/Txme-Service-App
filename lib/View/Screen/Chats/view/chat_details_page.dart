import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/message_controller.dart';
import '../model/chat_model.dart';
import '../../../Widgegt/MessageBubbleWidget/MessageBubble.dart';

class ChatDetailsPage extends StatefulWidget {
  final ChatModel chat;

  const ChatDetailsPage({super.key, required this.chat});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  late final MessageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MessageController(widget.chat.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.chat.avatar),
            ),
            const SizedBox(width: 12),
            Text(
              widget.chat.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(child: Text("No messages yet."));
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo_outlined, color: Colors.grey),
              onPressed: controller.sendImageMessage,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(() => IconButton(
              icon: Icon(
                Icons.send,
                color: controller.canSend.value ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                if (controller.canSend.value) {
                  controller.sendMessage();
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
