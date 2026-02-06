import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/core/network/socket_service.dart';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/core/utils/sound/sound_player.dart';
import 'package:vibration/vibration.dart';
import 'package:Travelon/core/navigation/app_navigator.dart';
import 'package:go_router/go_router.dart';

class GlobalAlertHost extends StatefulWidget {
  final Widget child;
  const GlobalAlertHost({super.key, required this.child});

  @override
  State<GlobalAlertHost> createState() => _GlobalAlertHostState();
}

class _GlobalAlertHostState extends State<GlobalAlertHost> {
  final SocketService _socketService = SocketService();
  bool _socketInitialized = false;

  bool _geofenceDialogOpen = false;
  bool _sosDialogOpen = false;
  Timer? _geofenceVibrationTimer;

  @override
  void initState() {
    super.initState();
    debugPrint("🟢 GlobalAlertHost mounted");
  }

  // ===================== SOCKET INIT =====================

  Future<void> _initSocketAfterLogin() async {
    if (_socketInitialized) return;

    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      debugPrint("❌ No token, cannot connect socket");
      return;
    }

    _socketInitialized = true;

    _socketService.connect(token);

    _socketService.onConnected(() {
      debugPrint("✅ Global socket connected");
    });

    _socketService.socket?.onAny((event, data) {
      debugPrint("📡 GLOBAL SOCKET EVENT: $event => $data");
    });

    _listenNearbySOS();
    _listenGeofenceAlerts();
  }

  void _listenNearbySOS() {
    final socket = _socketService.socket;
    if (socket == null) return;

    socket.on("nearbySOS", (data) {
      debugPrint("🚨 nearbySOS: $data");

      final double lat = (data['lat'] as num).toDouble();
      final double lng = (data['lng'] as num).toDouble();
      final int distance = (data['distanceMeters'] as num?)?.toInt() ?? 0;
      final String message = (data['message'] ?? "").toString();

      _showNearbySOSPopup(
        lat: lat,
        lng: lng,
        distance: distance,
        message: message,
      );
    });
  }


  void _listenGeofenceAlerts() {
    final socket = _socketService.socket;
    if (socket == null) return;

    socket.on("locationUpdate", (data) {
      debugPrint("🚧 locationUpdate: $data");

      final alert = data['alert'];
      if (alert != null && alert['type'] == "GEOFENCE_BREACH") {
        _showGeofenceAlertPopup(
          titleMessage: alert['message'] ?? "Geofence breached!",
          placeName: alert['placeName'] ?? "Unknown place",
          distanceMeters: (alert['distanceMeters'] as num?)?.toInt() ?? 0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => curr is AuthSuccess,
      listener: (context, state) {
        debugPrint("🔐 AuthSuccess detected in GlobalAlertHost");
        _initSocketAfterLogin();
      },
      child: widget.child,
    );
  }

  // ===================== GEOFENCE UI =====================

  Future<void> _showGeofenceAlertPopup({
    required String titleMessage,
    required String placeName,
    required int distanceMeters,
  }) async {
    if (_geofenceDialogOpen) return;
    _geofenceDialogOpen = true;

    await _startGeofenceAlertEffects();

    final ctx = rootNavigatorKey.currentState?.overlay?.context;
    if (ctx == null) {
      _geofenceDialogOpen = false;
      return;
    }

    await showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierLabel: "GeofenceAlert",
      barrierColor: Colors.black.withOpacity(0.85),
      pageBuilder: (context, _, __) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2A0000), Color(0xFF000000)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.red.withOpacity(0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.25),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _GeofencePulseIcon(),
                        const SizedBox(height: 20),
                        Text(
                          "RESTRICTED AREA",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          titleMessage,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _geoInfoRow("Place", placeName, theme),
                        const SizedBox(height: 8),
                        _geoInfoRow("Distance", "$distanceMeters m", theme),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _stopGeofenceAlertEffects();
                              Navigator.of(context, rootNavigator: true).pop();
                              _geofenceDialogOpen = false;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text("OK, TAKE ME BACK"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _geoInfoRow(String label, String value, ThemeData theme) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }


  // ===================== EFFECTS =====================

  Future<void> _startGeofenceAlertEffects() async {
    await SoundPlayer.playGeofenceWarningLoop();

    _geofenceVibrationTimer?.cancel();
    _geofenceVibrationTimer =
        Timer.periodic(const Duration(seconds: 2), (_) async {
          final hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(pattern: [0, 500, 300, 500]);
          }
        });
  }

  Future<void> _stopGeofenceAlertEffects() async {
    await SoundPlayer.stop();
    _geofenceVibrationTimer?.cancel();
    _geofenceVibrationTimer = null;
    await Vibration.cancel();
  }

  // ===================== SOS UI =====================

  void _showNearbySOSPopup({
    required double lat,
    required double lng,
    required int distance,
    required String message,
  }) async {
    if (_sosDialogOpen) return;
    _sosDialogOpen = true;

    await SoundPlayer.playSosAlert();

    final ctx = rootNavigatorKey.currentState?.overlay?.context;
    if (ctx == null) {
      _sosDialogOpen = false;
      return;
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 12,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔴 Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.error.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 40,
                    color: theme.colorScheme.error,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Nearby Emergency",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "A tourist near you needs help.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // 📍 Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.errorContainer.withOpacity(0.25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                        icon: Icons.social_distance,
                        label: "Distance",
                        value: "${distance} m",
                        theme: theme,
                      ),
                      const SizedBox(height: 8),
                      _infoRow(
                        icon: Icons.message_outlined,
                        label: "Message",
                        value: message.isEmpty ? "Emergency SOS" : message,
                        theme: theme,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔘 Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          SoundPlayer.stop();
                          Navigator.of(context, rootNavigator: true).pop();
                          _sosDialogOpen = false;
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: theme.colorScheme.onTertiary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text("Dismiss",style: TextStyle(
                          color: Colors.black
                        ),),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          SoundPlayer.stop();
                          Navigator.of(context, rootNavigator: true).pop();
                          _sosDialogOpen = false;

                          // 👉 Go to map with coordinates
                          final navCtx = rootNavigatorKey.currentState?.context;
                          if (navCtx != null) {
                            GoRouter.of(navCtx).go(
                              '/home',
                              extra: {
                                'lat': lat,
                                'lng': lng,
                              },
                            );
                          }

                        },
                        icon: Icon(Icons.map_rounded,color: theme.iconTheme.color,),
                        label: const Text("Go to Map"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

// ===================== PULSE ICON =====================

class _GeofencePulseIcon extends StatefulWidget {
  const _GeofencePulseIcon();

  @override
  State<_GeofencePulseIcon> createState() => _GeofencePulseIconState();
}

class _GeofencePulseIconState extends State<_GeofencePulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final scale = 1.0 + (_controller.value * 0.25);

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.25),
                ),
              ),
            ),
            const Icon(Icons.warning_amber_rounded,
                color: Colors.red, size: 96),
          ],
        );
      },
    );
  }
}
