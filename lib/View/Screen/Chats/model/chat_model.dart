import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../../service/api_url.dart';

// Helper function to format the timestamp
String _formatChatTimestamp(String isoString) {
  if (isoString.isEmpty) {
    return "";
  }
  try {
    final messageTime = DateTime.parse(isoString).toLocal();
    final now = DateTime.now();

    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfYesterday = startOfToday.subtract(const Duration(days: 1));
    final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));

    if (messageTime.isAfter(startOfToday)) {
      // Today: Show time like "3:00 PM"
      return DateFormat('h:mm a').format(messageTime);
    } else if (messageTime.isAfter(startOfYesterday)) {
      // Yesterday
      return 'Yesterday';
    } else if (messageTime.isAfter(startOfWeek)) {
      // Within the last week: Show day like "Monday"
      return DateFormat('EEEE').format(messageTime);
    } else {
      // Older than a week: Show date like "Jan 3"
      return DateFormat('MMM d').format(messageTime);
    }
  } catch (e) {
    debugPrint("Error parsing or formatting chat time: $e");
    return ""; // Return empty string if parsing fails
  }
}

class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String avatar;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatar,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String myUserId) {
    final participants = json['participants'] as List;
    dynamic other;

    if (participants.isNotEmpty && participants.first is String) {
      final otherId = participants.firstWhere((id) => id != myUserId, orElse: () => '');
      other = {
        "_id": otherId,
        "fullName": "User",
        "avatar": "",
      };
    } else {
      other = participants.firstWhere(
            (p) => p['_id'] != myUserId,
        orElse: () => participants.isNotEmpty ? participants.first : {},
      );
    }

    String avatarUrl = other['avatar'] ?? other['image'] ?? other['profileImage'] ?? other['profilePicture'] ?? "";

    if (avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
      avatarUrl = '${ApiConstant.baseUrl}$avatarUrl';
    }

    debugPrint("✅ Constructed Avatar URL: $avatarUrl");

    return ChatModel(
      id: json['_id'],
      name: other['fullName'] ?? "Unknown",
      lastMessage: json['lastMessage']?['text'] ?? "",
      time: _formatChatTimestamp(json['lastMessage']?['createdAt'] ?? ""),
      unreadCount: json['unreadCount'] ?? 0,
      avatar: avatarUrl,
    );
  }

  ChatModel copyWith({
    String? lastMessage,
    String? time,
    int? unreadCount,
    String? name,
    String? avatar,
  }) {
    return ChatModel(
      id: id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      avatar: avatar ?? this.avatar,
    );
  }
}
