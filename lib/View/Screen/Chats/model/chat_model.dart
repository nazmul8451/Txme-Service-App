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

    final participant = participants.firstWhere(
          (p) => p['_id'] != myUserId,
      orElse: () => participants.first,
    );

    return ChatModel(
      id: json['_id'],
      name: participant['fullName'] ?? "Unknown",
      lastMessage: json['lastMessage']?['text'] ?? "",
      time: json['lastMessage']?['createdAt'] ?? "",
      unreadCount: json['unreadCount'] ?? 0,
      avatar: participant['avatar'] ??
          "https://i.pravatar.cc/150?img=12",
    );
  }

  ChatModel copyWith({
    String? lastMessage,
    String? time,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id,
      name: name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      avatar: avatar,
    );
  }
}
