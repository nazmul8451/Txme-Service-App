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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      isMe: json['is_me'],
      time: json['time'],
    );
  }
}