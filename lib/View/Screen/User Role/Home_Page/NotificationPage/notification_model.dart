
import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
    final String id;
    final String title;
    final String message;
    final String receiver;
    final String screen;
    final bool read;
    final String type;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    NotificationModel({
        required this.id,
        required this.title,
        required this.message,
        required this.receiver,
        required this.screen,
        required this.read,
        required this.type,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["_id"],
        title: json["title"],
        message: json["message"],
        receiver: json["receiver"],
        screen: json["screen"],
        read: json["read"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "message": message,
        "receiver": receiver,
        "screen": screen,
        "read": read,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
