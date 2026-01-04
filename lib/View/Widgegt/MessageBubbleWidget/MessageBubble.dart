import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Screen/Chats/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

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
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Display Image if available
            if (message.type == 'IMAGE' && message.files.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  message.files.first, // Display the first image
                  width: 200.w, // Set a fixed width for the image
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
              ),

            // Display Text if available
            if (message.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ),

            // Display Time
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                message.time,
                style: TextStyle(
                  color: isMe ? Colors.white70 : Colors.black54,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
