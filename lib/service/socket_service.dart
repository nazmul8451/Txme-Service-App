import 'dart:async';
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

  /// ✅ USE STREAM INSTEAD OF LIST OF CALLBACKS
  final _messageController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get messageStream => _messageController.stream;

  Future<void> init() async {
    if (_initialized) return;

    final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);

    debugPrint("🔌 CONNECTING SOCKET... $token");

    try {
      socket = io.io(
        ApiConstant.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket', 'polling'])
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

      socket!.onConnectError((data) {
        debugPrint("❌ SOCKET CONNECT ERROR: $data");
      });

      socket!.on("message", (data) {
        debugPrint("📩 SOCKET MESSAGE RECEIVED: $data");
        _messageController.add(data);
      });

      socket!.connect();
      _initialized = true;
    } catch (e) {
      debugPrint("❌ SOCKET INIT ERROR: $e");
    }
  }

  // ✅ Listen to events
  void on(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
    debugPrint("🎧 Listening to: $event");
  }

  // ✅ Remove event listener
  void off(String event) {
    socket?.off(event);
    debugPrint("🔇 Stopped listening to: $event");
  }

  // ✅ NEW: Emit events - THIS WAS MISSING
  void emit(String event, [dynamic data]) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
      debugPrint("📡 Emitted: $event with data: $data");
    } else {
      debugPrint("⚠️ Cannot emit: Socket not connected");
      debugPrint("Socket exists: ${socket != null}, Connected: ${socket?.connected ?? false}");
    }
  }

  // Join chat room
  void joinChat(String chatId) {
    if (socket != null) {
      debugPrint("👉 JOINING CHAT: $chatId");
      emit("joinChat", {"chatId": chatId});
    }
  }

  // Leave chat room
  void leaveChat(String chatId) {
    if (socket != null) {
      debugPrint("👋 LEAVING CHAT: $chatId");
      emit("leaveChat", {"chatId": chatId});
    }
  }

  // Send message
  void sendMessage({
    required String chatId,
    required String text,
  }) {
    if (socket != null) {
      emit("sendMessage", {
        "chatId": chatId,
        "text": text,
        "type": "TEXT",
      });
    }
  }

  // ✅ Get connection status
  bool get isConnected => socket?.connected ?? false;

  // ✅ Disconnect socket
  void disconnect() {
    socket?.disconnect();
    _initialized = false;
    debugPrint("🔌 Socket manually disconnected");
  }

  // ✅ Dispose resources
  void dispose() {
    _messageController.close();
    socket?.dispose();
  }
}