import 'package:flutter/foundation.dart';

class MessageModel {
  final String id;
  final String message;
  final bool isMe;
  final String time;

  MessageModel({
    required this.id,
    required this.message,
    required this.isMe,
    required this.time,
  });

  factory MessageModel.fromJson(
      Map<String, dynamic> json,
      String myUserId,
      ) {
    dynamic sender = json['sender'];
    bool isMe = false;
    
    // Explicit Debug Log
    debugPrint("MessageModel: sender=$sender, myUserId=$myUserId");

    if (sender is String) {
      isMe = sender == myUserId;
    } else if (sender is Map) {
      // Check for both _id and id
      final senderId = sender['_id'] ?? sender['id'];
      isMe = senderId == myUserId;
    } else {
      // Fallback: sometimes senderId is at root
      final senderId = json['senderId'];
      if (senderId != null && senderId == myUserId) {
        isMe = true;
      }
    }
    
    // Double check if myUserId is empty - if so, we can't be sure, but usually default false.
    if (myUserId.isEmpty) {
       debugPrint("⚠️ IS_ME CHECK FAILED: myUserId is EMPTY");
    }

    // Force isMe if the sender implies it (e.g. from optimistic UI logic passed improperly, though rare)
    
    return MessageModel(
      id: json['_id'] ?? "unknown_${DateTime.now().millisecondsSinceEpoch}",
      message: json['text'] ?? "",
      isMe: isMe,
      time: json['createdAt'] ?? "",
    );
  }
}
