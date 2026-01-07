import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import 'package:txme_app/service/settings_service.dart'; // ✅ ADDED
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
  final SettingsService settingsService = Get.find<SettingsService>(); // ✅ ADDED

  @override
  void initState() {
    super.initState();
    controller = Get.put(MessageController(widget.chat.id));
  }

  void _showMoneyRequestDialog() {
    final textController = TextEditingController();
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text("Request Money"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: "Message",
                  hintText: "e.g., For lunch",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  prefixText: "€",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final text = textController.text;
                final amount = double.parse(amountController.text);
                controller.sendMoneyRequest(text: text, amount: amount);
                Get.back();
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
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
        actions: [
          // ✅ UPDATED: Conditionally hide based on both settings and admin support
          Obx(() {
            if (widget.chat.isAdminSupport || !settingsService.moneyRequestEnabled.value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red601,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showMoneyRequestDialog,
                  child: const Text("Money Request", style: TextStyle(color: AppColors.FFFFFF))),
            );
          })
        ],
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
