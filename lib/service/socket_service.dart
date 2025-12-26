import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../helper/shared_prefe/shared_prefe.dart';
import 'api_url.dart';

class SocketApi {
  SocketApi._internal();
  static final SocketApi _instance = SocketApi._internal();
  factory SocketApi() => _instance;

  io.Socket? socket;
  bool _initialized = false;

  final _messageCallbacks = <Function(dynamic)>[];

  Future<void> init() async {
    if (_initialized) return;

    final token =
    await SharePrefsHelper.getString(ApiConstant.bearerToken);

    socket = io.io(
      ApiConstant.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    socket!.onConnect((_) {
      debugPrint("🟢 SOCKET CONNECTED");
    });

    socket!.onDisconnect((_) {
      debugPrint("🔴 SOCKET DISCONNECTED");
    });

    socket!.on("message", (data) {
      for (final cb in _messageCallbacks) {
        cb(data);
      }
    });

    socket!.connect();
    _initialized = true;
  }

  void onMessage(Function(dynamic) callback) {
    _messageCallbacks.add(callback);
  }

  void joinChat(String chatId) {
    socket?.emit("joinChat", {"chatId": chatId});
  }

  void leaveChat(String chatId) {
    socket?.emit("leaveChat", {"chatId": chatId});
  }

  void sendMessage({
    required String chatId,
    required String text,
  }) {
    socket?.emit("sendMessage", {
      "chatId": chatId,
      "text": text,
      "type": "TEXT",
    });
  }
}

