
import 'dart:nativewrappers/_internal/vm/bin/common_patch.dart' as io;

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../helper/shared_prefe/shared_prefe.dart';
import 'api_url.dart';

class SocketApi {
  /// Singleton instance
  SocketApi._internal();
  static final SocketApi _instance = SocketApi._internal();
  factory SocketApi() => _instance;

  late io.Socket socket;

  /// ================= INIT SOCKET =================
  Future<void> init() async {
    final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);

    socket = io.io(
      ApiConstant.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({
        'Authorization': 'Bearer $token',
      })
          .build(),
    );

    _registerListeners();
  }

  /// ================= LISTENERS =================
  void _registerListeners() {
    socket.onConnect((_) {
      debugPrint('🟢 SOCKET CONNECTED: ${socket.id}');
    });

    socket.onDisconnect((_) {
      debugPrint('🔴 SOCKET DISCONNECTED');
    });

    socket.onConnectError((error) {
      debugPrint('❌ SOCKET CONNECT ERROR: $error');
    });

    socket.onError((error) {
      debugPrint('❌ SOCKET ERROR: $error');
    });

    socket.on('unauthorized', (data) {
      debugPrint('🚫 SOCKET UNAUTHORIZED: $data');
    });
  }

  /// ================= EMIT =================
  void emit(String event, dynamic data) {
    if (socket.connected) {
      socket.emit(event, data);
    } else {
      debugPrint('⚠️ Socket not connected');
    }
  }

  /// ================= LISTEN =================
  void on(String event, Function(dynamic data) callback) {
    socket.on(event, callback);
  }

  /// ================= DISPOSE =================
  void disconnect() {
    socket.disconnect();
    socket.dispose();
  }
}
