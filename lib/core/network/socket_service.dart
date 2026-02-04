import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected == true;

  void connect(String token) {
    if (_socket != null && _socket!.connected) {
      debugPrint("🔁 Socket already connected");
      return;
    }

    _socket = IO.io(
      "http://103.207.1.87:5821", // ⚠️ change this
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint("✅ Socket connected");

      // 🔐 Join role room AFTER connect
      _socket!.emit("joinRoleRoom", token);
    });

    _socket!.on("error", (data) {
      debugPrint("📡 SOCKET EVENT: error => $data");
    });

    _socket!.onDisconnect((_) {
      debugPrint("❌ Socket disconnected");
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
