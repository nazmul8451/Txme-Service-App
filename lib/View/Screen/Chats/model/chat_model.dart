class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String avatar;
  final String time;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatar,
    required this.time,
    required this.unreadCount,
  });

  /// API / Socket data support
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      lastMessage: json['last_message'],
      avatar: json['avatar'],
      time: json['time'],
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
