import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

/// Centralized service for managing Socket.IO connection with the backend.
///
/// Handles:
/// - Real-time location updates
/// - SOS signals
/// - Geofencing events
class SocketService {
  // Singleton instance to ensure only one socket connection exists
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected == true;

  /// Establishes a socket connection with the backend.
  ///
  /// [token] is used to join the appropriate role room
  /// after the connection is established.
  void connect(String token) {
    if (_socket != null && _socket!.connected) {
      return;
    }

    // Load Socket URL from .env to avoid hardcoding sensitive configuration

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
      _socket!.emit("joinRoleRoom", token);
    });

    _socket!.on("error", (data) {});

    _socket!.onDisconnect((_) {});

    _socket!.connect();
  }

  /// Executes [cb] when the socket is connected.
  ///
  /// If the socket is already connected, the callback
  /// is executed immediately.
  void onConnected(VoidCallback cb) {
    if (_socket == null) return;

    if (_socket!.connected) {
      cb();
    } else {
      _socket!.onConnect((_) => cb());
    }
  }

  /// Disconnects the active socket connection and clears the instance.
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
