import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../../service/api_url.dart';

class MessageModel {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final String type; // e.g., 'TEXT', 'IMAGE'
  final List<String> files; // List of image URLs

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.type,
    required this.files,
  });

  factory MessageModel.fromJson(
      Map<String, dynamic> json,
      String myUserId,
      ) {
    dynamic sender = json['sender'];
    bool isMe = false;

    if (sender is String) {
      isMe = sender == myUserId;
    } else if (sender is Map) {
      final senderId = sender['_id'] ?? sender['id'];
      isMe = senderId == myUserId;
    }

    // Time Formatting
    String formattedTime = "";
    if (json['createdAt'] != null && json['createdAt'].isNotEmpty) {
      try {
        DateTime parsedTime = DateTime.parse(json['createdAt']).toLocal();
        formattedTime = DateFormat('HH:mm').format(parsedTime);
      } catch (e) {
        debugPrint("Error parsing time: ${json['createdAt']}");
      }
    }

    // Image URL Formatting
    List<String> fileUrls = [];
    if (json['files'] != null && json['files'] is List) {
      fileUrls = (json['files'] as List).map((file) {
        if (file.toString().startsWith('http')) {
          return file.toString();
        } else {
          return '${ApiConstant.baseUrl}$file';
        }
      }).toList();
    }

    return MessageModel(
      id: json['_id'] ?? "unknown_${DateTime.now().millisecondsSinceEpoch}",
      text: json['text'] ?? "",
      isMe: isMe,
      time: formattedTime,
      type: json['type'] ?? 'TEXT',
      files: fileUrls,
    );
  }
}
