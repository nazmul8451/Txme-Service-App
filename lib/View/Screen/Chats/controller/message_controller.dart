import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../helper/Shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/socket_service.dart';
import '../model/message_model.dart';
import 'chat_controller.dart';

class MessageController extends GetxController {
  final String chatId;
  MessageController(this.chatId);

  StreamSubscription? _socketSubscription;

  final SocketApi socketApi = SocketApi();

  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  RxString chatName = "".obs;
  RxString chatAvatar = "".obs;
  final canSend = false.obs;

  late String myUserId;

  @override
  void onInit() {
    super.onInit();
    messageController.addListener(() {
      canSend.value = messageController.text.isNotEmpty;
    });
    _init();
  }

  Future<void> _init() async {
    final fetchedId = await SharePrefsHelper.getString(SharePrefsHelper.userId);
    myUserId = fetchedId;
    debugPrint("👤 My User ID loaded: $myUserId");

    if (myUserId.isEmpty) {
      debugPrint("❌ ERROR: User ID is empty! Cannot determine 'isMe'.");
    }

    socketApi.joinChat(chatId);
    await getMessages();

    final eventName = "getMessage::$chatId";
    debugPrint("🎧 Listening to Socket Event: $eventName");

    socketApi.on(eventName, (data) {
      debugPrint("📩 EVENT RECEIVED [$eventName]: $data");
      if (data == null) return;

      final raw = data['message'] ?? data;

      try {
        final msg = MessageModel.fromJson(raw, myUserId);
        debugPrint("🧩 Parsed Socket Message: ${msg.text} | isMe: ${msg.isMe}");

        if (messages.any((m) => m.id == msg.id)) {
          debugPrint("⚠️ Duplicate Message ID ignored: ${msg.id}");
          return;
        }

        if (msg.isMe) {
          final tempIndex = messages.indexWhere((m) => m.id.startsWith("temp_") && m.text == msg.text);
          if (tempIndex != -1) {
            debugPrint("🔄 Replacing Temp Message with Socket Message");
            messages[tempIndex] = msg;
            return;
          }
        }

        messages.insert(0, msg);

      } catch (e) {
        debugPrint("❌ Message Parse Error: $e");
      }
    });

    // ✅ Listen for edit message events - using getMessage pattern
    socketApi.on(eventName, (data) {
      if (data == null) return;

      // Check if this is an edit event
      if (data['action'] == 'edit' || data['type'] == 'edit') {
        debugPrint("✏️ EDIT EVENT RECEIVED: $data");
        try {
          final raw = data['message'] ?? data;
          final messageId = raw['_id'] ?? raw['messageId'];

          if (messageId != null) {
            final index = messages.indexWhere((m) => m.id == messageId);
            if (index != -1) {
              final updatedMsg = MessageModel.fromJson(raw, myUserId);
              messages[index] = updatedMsg;
              update();
              debugPrint("✅ Message updated via socket: $messageId");
            }
          }
        } catch (e) {
          debugPrint("❌ Edit Message Parse Error: $e");
        }
      }

      // Check if this is a delete event
      if (data['action'] == 'delete' || data['type'] == 'delete') {
        debugPrint("🗑️ DELETE EVENT RECEIVED: $data");
        try {
          final messageId = data['messageId'] ?? data['_id'];

          if (messageId != null) {
            messages.removeWhere((m) => m.id == messageId);
            update();
            debugPrint("✅ Message deleted via socket: $messageId");
          }
        } catch (e) {
          debugPrint("❌ Delete Message Parse Error: $e");
        }
      }
    });
  }

  Future<void> getMessages() async {
    final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);
    print(token);
    final response = await http.get(
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.apiVersion}/message/$chatId?page=1&limit=10000"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded['data'] is Map ? decoded['data']['messages'] : decoded['data'];

      if (decoded['data'] is Map && decoded['data']['participant'] != null) {
        final p = decoded['data']['participant'];
        chatName.value = p['fullName'] ?? chatName.value;
        chatAvatar.value = p['profilePicture'] ?? p['avatar'] ?? chatAvatar.value;
      }

      messages.value = list
          .map<MessageModel>((e) => MessageModel.fromJson(e, myUserId))
          .toList()
          .reversed
          .toList();
      update();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";

    messages.insert(0,
      MessageModel(
        id: tempId,
        text: text,
        isMe: true,
        time: "now",
        type: 'TEXT',
        files: [],
      ),
    );
    update();

    messageController.clear();

    socketApi.sendMessage(
      chatId: chatId,
      text: text,
    );

    try {
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().updateLastMessage(chatId, text);
      }
    } catch (e) {
      debugPrint("Error updating Chat List: $e");
    }

    try {
      final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);
      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.message}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "chatId": chatId,
          "text": text,
          "type": "TEXT",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final savedMsg = MessageModel.fromJson(decoded['data'], myUserId);

        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = savedMsg;
          update();
        }
      } else {
        debugPrint("❌ Message save failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Message API error: $e");
    }
  }

  // ✅ UPDATED: Edit Message - Socket will handle via backend
  Future<void> editMessage(String messageId, String newText) async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.message}/$messageId";

      debugPrint("✏️ Editing message: $url");

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'text': newText}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Update local message immediately
        final index = messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          messages[index] = MessageModel.fromJson(decoded['data'], myUserId);
          update();
        }

        // Backend should emit socket event to other users
        // If your backend doesn't do this, uncomment below:
        /*
        try {
          socketApi.socket?.emit('editMessage', {
            'chatId': chatId,
            'messageId': messageId,
            'text': newText,
            'message': decoded['data'],
          });
          debugPrint("📡 Socket emitted: editMessage");
        } catch (e) {
          debugPrint("⚠️ Socket emit failed: $e");
        }
        */

      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorBody['message'] ?? "Failed to edit message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Edit error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ✅ UPDATED: Delete Message - Socket will handle via backend
  Future<void> deleteMessage(String messageId) async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.message}/$messageId";

      debugPrint("🗑️ Deleting message: $url");

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Remove from local list immediately
        messages.removeWhere((m) => m.id == messageId);
        update();

        // Backend should emit socket event to other users
        // If your backend doesn't do this, uncomment below:
        /*
        try {
          socketApi.socket?.emit('deleteMessage', {
            'chatId': chatId,
            'messageId': messageId,
          });
          debugPrint("📡 Socket emitted: deleteMessage");
        } catch (e) {
          debugPrint("⚠️ Socket emit failed: $e");
        }
        */

      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar(
          "",
          errorBody['message'] ?? "Failed to delete message",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Delete error: $e");
      Get.snackbar(
        "",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendMoneyRequest({
    required String text,
    required double amount,
  }) async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}${ApiConstant.moneyRequestMessage}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "chatId": chatId,
          "text": text,
          "type": "MONEY_REQUEST",
          "amount": amount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        getMessages();
        Get.snackbar("Success", "Money request sent!");
      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar(errorBody['message'] ?? "Failed to send request", "");
      }
    } catch (e) {
      Get.snackbar("An unexpected error occurred.", "");
    }
  }

  Future<void> respondToMoneyRequest(String messageId, String status) async {
    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.message}/$messageId/money-request";

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        getMessages();
        Get.snackbar("Success", "Request has been $status");
      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar(errorBody['message'] ?? "Failed to respond to request", "");
      }
    } catch (e) {
      Get.snackbar("An unexpected error occurred.", "");
    }
  }

  Future<void> sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    try {
      final token = await SharePrefsHelper.getString(SharePrefsHelper.bearerToken);
      final url = "${ApiConstant.baseUrl}${ApiConstant.message}";
      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['chatId'] = chatId;
      request.fields['type'] = 'IMAGE';

      final mimeType = lookupMimeType(pickedFile.path);
      debugPrint("✅ MIME Type: $mimeType");

      final file = await http.MultipartFile.fromPath(
        'messageFiles',
        pickedFile.path,
        filename: pickedFile.name,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );

      request.files.add(file);

      final response = await request.send();

      if (response.statusCode == 201) {
        getMessages();
        print("Image sent successfully");
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Failed to send image: ${response.statusCode} - $responseBody");
        Get.snackbar("Failed to send image", "");
      }
    } catch (e) {
      print("Error sending image: $e");
      Get.snackbar("An error occurred while sending the image", "");
    }
  }

  @override
  void onClose() {
    socketApi.off("getMessage::$chatId");
    socketApi.leaveChat(chatId);
    messageController.dispose();
    update();
    super.onClose();
  }
}