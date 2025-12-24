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
    return MessageModel(
      id: json['_id'],
      message: json['text'] ?? "",
      isMe: json['sender']?['_id'] == myUserId,
      time: json['createdAt'] ?? "",
    );
  }
}
