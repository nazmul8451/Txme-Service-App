import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Screen/Chats/controller/message_controller.dart';
import '../../Screen/Chats/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  // ✅ ADDED: Confirmation Dialog
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
              Get.back(); // Close the dialog
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

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final isMoneyRequest = message.type == 'MONEY_REQUEST';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
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
                      // ✅ UPDATED: Show buttons or status based on moneyRequestStatus
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
    );
  }
}
