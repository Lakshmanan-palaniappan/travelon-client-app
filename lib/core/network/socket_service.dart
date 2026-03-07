import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final socketUrl = dotenv.env['SOCKET_URL'];
    if (socketUrl == null || socketUrl.isEmpty) {
      throw Exception('SOCKET_URL not found in .env');
    }
    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableReconnection()
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint(" Socket connected");
      _socket!.emit("joinRoleRoom", token);
    });

    _socket!.on("error", (data) {
      debugPrint(" SOCKET EVENT: error => $data");
    });

    _socket!.onDisconnect((_) {
      debugPrint("Socket disconnected");
    });

    _socket!.connect();
  }

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
