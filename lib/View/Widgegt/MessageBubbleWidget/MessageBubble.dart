import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Screen/Chats/controller/message_controller.dart';
import '../../Screen/Chats/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  // ✅ Money Request Confirmation Dialog
  void _showConfirmationDialog(BuildContext context, String status) {
    final isAccept = status == 'accepted';
    Get.dialog(
      AlertDialog(
        title: Text(isAccept ? "Accept Request?" : "Reject Request?"),
        content: Text(
            "Are you sure you want to ${isAccept ? 'accept the €${message.amount!.toStringAsFixed(2)}' : 'reject this'} request?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.find<MessageController>().respondToMoneyRequest(message.id, status);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccept ? Colors.green : Colors.red,
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Show Edit/Delete Options (Messenger style)
  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Option
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Edit'),
                  onTap: () {
                    Get.back(); // Close bottom sheet
                    _showEditDialog(context);
                  },
                ),
                Divider(height: 1.h),
                // Delete Option
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Get.back(); // Close bottom sheet
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ NEW: Edit Message Dialog
  void _showEditDialog(BuildContext context) {
    final controller = Get.find<MessageController>();
    final textController = TextEditingController(text: message.text);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter new message',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = textController.text.trim();
              if (newText.isNotEmpty && newText != message.text) {
                controller.editMessage(message.id, newText);
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Delete Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.find<MessageController>().deleteMessage(message.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final isMoneyRequest = message.type == 'MONEY_REQUEST';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        // ✅ NEW: Long Press to show options (only for own messages)
        onLongPress: isMe ? () => _showMessageOptions(context) : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Display Image
              if (message.type == 'IMAGE' && message.files.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    message.files.first,
                    width: 200.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                    progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stack) =>
                    const Icon(Icons.error, color: Colors.red),
                  ),
                ),

              // Display Text
              if (message.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    message.text,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14.sp),
                  ),
                ),

              // Display Money Request
              if (isMoneyRequest && message.amount != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Requesting: €${message.amount!.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.white : Colors.black, fontSize: 15.sp),
                      ),
                      if (!isMe) ...[
                        SizedBox(height: 10.h),
                        if (message.moneyRequestStatus == 'pending')
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () => _showConfirmationDialog(context, 'accepted'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Accept", style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(width: 10.w),
                              OutlinedButton(
                                onPressed: () => _showConfirmationDialog(context, 'rejected'),
                                child: const Text("Reject"),
                              ),
                            ],
                          )
                        else if (message.moneyRequestStatus == 'accepted')
                          const Text("Accepted", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                        else if (message.moneyRequestStatus == 'rejected')
                            const Text("Rejected", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ]
                    ],
                  ),
                ),

              // Display Time
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  message.time,
                  style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}