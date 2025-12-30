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
    
    if (sender is String) {
      isMe = sender == myUserId;
    } else if (sender is Map) {
      isMe = sender['_id'] == myUserId;
    }

    return MessageModel(
      id: json['_id'],
      message: json['text'] ?? "",
      isMe: isMe,
      time: json['createdAt'] ?? "",
    );
  }
}
