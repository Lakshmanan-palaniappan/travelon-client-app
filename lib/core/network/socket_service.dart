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
      "http://103.207.1.87:5821",
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // ✅ allow fallback
          .enableReconnection()
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );


    _socket!.onConnect((_) {
      debugPrint("✅ Socket connected");
      _socket!.emit("joinRoleRoom", token); // join room
    });

    _socket!.on("error", (data) {
      debugPrint("📡 SOCKET EVENT: error => $data");
    });

    _socket!.onDisconnect((_) {
      debugPrint("❌ Socket disconnected");
    });

    _socket!.connect();
  }

  // 👇 ADD THIS
  void onConnected(VoidCallback cb) {
    if (_socket == null) return;

    if (_socket!.connected) {
      cb();
    } else {
      _socket!.onConnect((_) => cb());
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}

