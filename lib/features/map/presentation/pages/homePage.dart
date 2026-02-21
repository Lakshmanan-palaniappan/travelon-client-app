import 'dart:async';

import 'package:Travelon/core/di/injection_container.dart';
import 'package:Travelon/core/network/socket_service.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/HomeDrawer.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/map/presentation/cubit/gps_cubit.dart';
import 'package:Travelon/features/map/presentation/cubit/wifi_cubit.dart';
import 'package:Travelon/features/sos/presentation/cubit/sos_cubit.dart';
import 'package:Travelon/features/sos/presentation/cubit/sos_state.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/AssignedEmployeeCard.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/show_assigned_employee_sheet.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/show_employee_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:Travelon/core/utils/sound/sound_player.dart';
import 'package:vibration/vibration.dart';
import 'package:Travelon/features/sos/data/sos_countDown.dart';
import '../../../../core/widgets/global_alert_host.dart';

import '../../../../core/utils/theme/AppColors.dart';
import '../../../../core/utils/token_storage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _SosMarker {
  final LatLng position;
  final DateTime expiresAt;

  _SosMarker({required this.position, required this.expiresAt});
}

class _HomepageState extends State<Homepage> {
  final List<_SosMarker> _activeSosMarkers = [];
  Timer? _sosCleanupTimer;
  bool _followUserLocation = true;

  Timer? _cooldownTimer;
  final ValueNotifier<Duration> _cooldownLeftNotifier = ValueNotifier<Duration>(
    Duration.zero,
  );

  bool get _isInCooldown => _cooldownLeftNotifier.value.inSeconds > 0;

  final MapController _mapController = MapController();

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  List<Marker> _buildMarkers({
    required GpsState gpsState,
    required LocationState wifiState,
  }) {
    final markers = <Marker>[];

    // GPS marker
    if (gpsState.location != null) {
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: gpsState.location!,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 36),
        ),
      );
    }

    // WiFi marker
    if (wifiState is LocationLoaded) {
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: LatLng(wifiState.location.lat, wifiState.location.lng),
          child: const Icon(Icons.location_pin, color: Colors.red, size: 42),
        ),
      );
    }

    // ✅ SOS markers
    for (final sos in _activeSosMarkers) {
      debugPrint("🗺 SOS markers rendered: ${_activeSosMarkers.length}");

      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: sos.position,
          child: _SosPulseMarker(),
          // later replace with: child: _SosPulseMarker(),
        ),
      );
    }

    return markers;
  }

  Future<void> _addSosMarker(double lat, double lng) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 1200);
      }
    } catch (e) {
      debugPrint("⚠️ Vibration not available: $e");
    }

    final expiresAt = DateTime.now().add(const Duration(minutes: 2));

    setState(() {
      _activeSosMarkers.add(
        _SosMarker(position: LatLng(lat, lng), expiresAt: expiresAt),
      );
      _followUserLocation = false;
    });

    debugPrint("🟥 Active SOS markers count: ${_activeSosMarkers.length}");
    debugPrint("📍 SOS at: $lat, $lng");

    _mapController.move(LatLng(lat, lng), 17);
    _startSosCleanupTimer();
  }

  Future<void> _startCooldown(Duration duration) async {
    _cooldownTimer?.cancel();

    final endTime = DateTime.now().add(duration);

    _cooldownLeftNotifier.value = duration;
    await SosCooldownStorage.saveEnd(endTime);

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
      final left = endTime.difference(DateTime.now());

      if (left.isNegative || left.inSeconds == 0) {
        t.cancel();
        await SosCooldownStorage.clear();
        _cooldownLeftNotifier.value = Duration.zero;
      } else {
        _cooldownLeftNotifier.value = left;
      }
    });
  }

  void _startSosCleanupTimer() {
    _sosCleanupTimer ??= Timer.periodic(const Duration(seconds: 10), (_) {
      final now = DateTime.now();

      setState(() {
        _activeSosMarkers.removeWhere((m) => m.expiresAt.isBefore(now));
      });

      if (_activeSosMarkers.isEmpty) {
        _sosCleanupTimer?.cancel();
        _sosCleanupTimer = null;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final state = GoRouterState.of(context);
    final extra = state.extra;

    if (extra is Map<String, dynamic> &&
        extra.containsKey('lat') &&
        extra.containsKey('lng')) {
      final double lat = extra['lat'];
      final double lng = extra['lng'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addSosMarker(lat, lng);
      });
    }
  }

  @override
  void dispose() {
    _sosCleanupTimer?.cancel();
    _cooldownTimer?.cancel();
    _cooldownLeftNotifier.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load trip & GPS as before
      context.read<TripBloc>().add(FetchCurrentTrip());
      context.read<GpsCubit>().fetchCurrentLocation(context);

      // Restore SOS cooldown if any
      final end = await SosCooldownStorage.loadEnd();
      if (end != null) {
        final diff = end.difference(DateTime.now());
        if (!diff.isNegative) {
          _startCooldown(diff);
        } else {
          await SosCooldownStorage.clear();
        }
      }

      // Setup socket
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    final authState = context.watch<AuthBloc>().state;
    final tourist = authState is AuthSuccess ? authState.tourist : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // drawer: const HomeDrawer(),
      // drawerEnableOpenDragGesture: false,
      body: MultiBlocListener(
        listeners: [
          //           BlocListener<TripBloc, TripState>(
          //   listener: (context, state) {
          //     if (state is AssignedEmployeeLoaded && state.employee != null) {
          //       final auth = context.read<AuthBloc>().state;
          //       if (auth is! AuthSuccess) return;

          //       InjectionContainer.locationSyncService.start(
          //         touristId: int.parse(auth.tourist.id!),
          //         getGps: () => context.read<GpsCubit>().state.location,
          //       );
          //     }

          //     if (state is AssignedEmployeeError) {
          //       InjectionContainer.locationSyncService.stop();
          //     }
          //   },
          // ),
          // BlocListener<TripBloc, TripState>(
          //   listener: (context, state) {
          //     final locationService = InjectionContainer.locationSyncService;
          //     final gpsCubit = context.read<GpsCubit>();

          //     if (state is CurrentTripLoaded) {
          //       final trip = state.trip;

          //       final auth = context.read<AuthBloc>().state;
          //       if (auth is! AuthSuccess) return;

          //       final touristId = int.parse(auth.tourist.id!);

          //       if (trip == null) {
          //         debugPrint("⚠️ No valid trip, stopping location sync");
          //         locationService.stop();
          //         return;
          //       }

          //       locationService.start(
          //         touristId: touristId,
          //         getGps: () => gpsCubit.state.location,
          //       );
          //     }

          //     if (state is NoCurrentTrip) {
          //       locationService.stop();
          //     }
          //   },
          //   child: const SizedBox.shrink(),
          // ),
          BlocListener<TripBloc, TripState>(
            listener: (context, state) {
              final locationService = InjectionContainer.locationSyncService;
              final gpsCubit = context.read<GpsCubit>();
              final wifiCubit = context.read<WifiCubit>();

              // !!!!!!!!! Location sending logic Disabled for debugging !!!!!!!!!!!!!!
              if (state is CurrentTripLoaded) {
                if (state.trip.isOngoing) {
                  locationService.start(
                    touristId: state.trip.touristId,
                    getGps: () => gpsCubit.state.location,
                    getWifi: () => wifiCubit.state.accessPoints,
                    getAccuracy: () => gpsCubit.state.accuracy,
                  );

                  context.read<TripBloc>().add(FetchAssignedEmployee());
                } else {
                  locationService.stop();
                }
              }

              if (state is NoCurrentTrip) {
                locationService.stop();
              }
            },
          ),
          // BlocListener<SosCubit, SosState>(
          //   listenWhen: (prev, curr) => curr is SosSuccess || curr is SosError,
          //   listener: (context, state) {
          //     if (state is SosSuccess) {
          //       SuccessFlash.show(context, message: "SOS sent Succefully");
          //     }
          //     if (state is SosError) {
          //       ErrorFlash.show(context, message: "SOS sent Failed");
          //     }
          //   },
          // ),

          /// 📡 WI-FI LOCATION
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationError) {
                // ErrorFlash.show(
                //   context,
                //   title: "Wi-Fi Location Failed",
                //   message: "Switching to GPS…",
                // );

                context.read<GpsCubit>().fetchCurrentLocation(context);
              }

              if (state is LocationLoaded && _followUserLocation) {
                _mapController.move(
                  LatLng(state.location.lat, state.location.lng),
                  17,
                );
              }
            },
          ),

          BlocListener<GpsCubit, GpsState>(
            listener: (context, state) {
              if (state.location != null && _followUserLocation) {
                _mapController.move(state.location!, 16);
              }
            },
          ),

          BlocListener<SosCubit, SosState>(
            listener: (context, state) {
              // ✅ When SOS sent successfully → start 2 min cooldown
              if (state is SosSuccess) {
                SuccessFlash.show(context, message: "SOS sent successfully");
                _startCooldown(const Duration(minutes: 2));
              }

              // ⛔ When backend says cooldown (429)
              if (state is SosError && state.statusCode == 429) {
                final seconds = state.secondsRemaining ?? 0;

                ErrorFlash.show(
                  context,
                  message:
                      "Please wait $seconds seconds before sending SOS again",
                );

                _startCooldown(Duration(seconds: seconds));
              }

              // ❌ Other errors
              if (state is SosError && state.statusCode != 429) {
                ErrorFlash.show(context, message: state.message!);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            Builder(
              builder: (context) {
                final gpsState = context.watch<GpsCubit>().state;
                final wifiState = context.watch<LocationBloc>().state;

                final markers = _buildMarkers(
                  gpsState: gpsState,
                  wifiState: wifiState,
                );

                return _MapView(
                  mapController: _mapController,
                  isDark: isDark,
                  markers: markers,
                  initialCenter:
                      gpsState.location ?? const LatLng(10.8505, 76.2711),
                );
              },
            ),

            /// ⏳ LOADER (GPS or WIFI)
            ValueListenableBuilder<Duration>(
              valueListenable: _cooldownLeftNotifier,
              builder: (context, left, _) {
                if (left.inSeconds <= 0) return const SizedBox.shrink();

                return Positioned(
                  top: 100,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "You can send SOS again in ${_formatDuration(left)}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              },
            ),

            Positioned(
              bottom: 20,
              left: 16,
              child: Text(
                "TRAVELON",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isDark
                          ? AppColors.darkUtilPrimary
                          : AppColors.lightUtilPrimary,
                ),
              ),
            ),

            // 🔘 VIEW ASSIGNED EMPLOYEE BUTTON
            // Positioned(
            //   bottom: 20,
            //   left: 16,
            //   right: 16,
            //   child: MyElevatedButton(
            //     text: "View Assigned Employee",
            //     onPressed: () {
            //       context.read<TripBloc>().add(FetchAssignedEmployee());
            //     },
            //   ),
            // ),

            // ✅ ASSIGNED EMPLOYEE RESULT (FIXED)
            // Positioned(
            //   bottom: 150,
            //   right: 16,
            //   child: BlocBuilder<TripBloc, TripState>(
            //     buildWhen:
            //         (prev, curr) =>
            //             curr is AssignedEmployeeLoaded ||
            //             curr is AssignedEmployeeLoading ||
            //             curr is AssignedEmployeeError,
            //     builder: (context, state) {
            //       // ❌ No employee → don't show button
            //       if (state is! AssignedEmployeeLoaded ||
            //           state.employee == null) {
            //         print("employee not assigned");
            //         return const SizedBox.shrink();
            //       }
            //
            //       return FloatingActionButton(
            //         heroTag: "employee",
            //         shape: const CircleBorder(),
            //         onPressed: () {
            //           // showAssignedEmployeeSheet(context, state.employee!);
            //           showEmployeePopup(context, state.employee!);
            //         },
            //         child: const Icon(Icons.badge_rounded),
            //       );
            //     },
            //   ),
            // ),
            Positioned(
              top: 40,
              right: 16,
              child: Builder(
                builder:
                    (context) => Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ValueListenableBuilder<Duration>(
                        valueListenable: _cooldownLeftNotifier,
                        builder: (context, left, _) {
                          final disabled = left.inSeconds > 0;

                          return IconButton(
                            icon: const Icon(Icons.sos),
                            onPressed:
                                disabled
                                    ? null
                                    : () {
                                      showSosDialog(
                                        context: context,
                                        onConfirm: (userMessage) {
                                          final gps =
                                              context.read<GpsCubit>().state;
                                          final wifi =
                                              context.read<WifiCubit>().state;

                                          final hasGps = gps.location != null;
                                          final hasWifi =
                                              wifi.accessPoints.isNotEmpty;

                                          if (!hasGps && !hasWifi) {
                                            ErrorFlash.show(
                                              context,
                                              message:
                                                  "Unable to get location. Try again.",
                                            );
                                            return;
                                          }

                                          final message =
                                              userMessage.isEmpty
                                                  ? "Emergency SOS"
                                                  : userMessage;

                                          context.read<SosCubit>().trigger(
                                            lat: gps.location?.latitude,
                                            lng: gps.location?.longitude,
                                            accuracy: gps.accuracy,
                                            wifiAccessPoints:
                                                wifi.accessPoints
                                                    .map(
                                                      (ap) => {
                                                        "macAddress": ap.bssid,
                                                        "signalStrength":
                                                            ap.level,
                                                      },
                                                    )
                                                    .toList(),
                                            message: message,
                                          );
                                        },
                                      );
                                    },
                          );
                        },
                      ),
                    ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: Builder(
                builder:
                    (context) => Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.onTertiary,
                      child: IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        // onPressed:
                        //     () => Scaffold.of(context).openDrawer(),
                        onPressed: () {
                          context.push('/menu');
                        },
                      ),
                    ),
              ),
            ),
            // Positioned(
            //   top: 200,
            //   left: 16,
            //   child: Builder(
            //     builder:
            //         (context) => Material(
            //           elevation: 4,
            //           shape: const CircleBorder(),
            //           color: Theme.of(context).colorScheme.surface,
            //           child: IconButton(
            //             icon: const Icon(Icons.refresh),
            //             onPressed: () {
            //               context.read<TripBloc>().add(FetchCurrentTrip());
            //             },
            //           ),
            //         ),
            //   ),
            // ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// 👤 ASSIGNED EMPLOYEE
          BlocBuilder<TripBloc, TripState>(
            buildWhen:
                (prev, curr) =>
                    curr is AssignedEmployeeLoaded ||
                    curr is AssignedEmployeeLoading ||
                    curr is AssignedEmployeeError,
            builder: (context, state) {
              if (state is! AssignedEmployeeLoaded || state.employee == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FloatingActionButton(
                  heroTag: "employee",
                  shape: const CircleBorder(),
                  onPressed: () {
                    showEmployeePopup(context, state.employee!);
                  },
                  child: const Icon(Icons.badge_rounded),
                ),
              );
            },
          ),

          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.onTertiary,
            heroTag: "gps",
            onPressed: () {
              setState(() {
                _followUserLocation = true; // ✅ resume following user
              });
              context.read<GpsCubit>().fetchCurrentLocation(context);
            },
            child: Icon(
              Icons.my_location,
              color: Theme.of(context).iconTheme.color,
            ),
          ),

          const SizedBox(height: 12),

          /// 📡 WIFI (if you re-enable later)
          // FloatingActionButton(
          //   backgroundColor: Theme.of(context).colorScheme.onTertiary,
          //   heroTag: "wifi",
          //   onPressed: () {
          //     if (tourist == null) return;
          //     context.read<LocationBloc>().add(
          //       GetLocationEvent(int.parse(tourist.id ?? '1')),
          //     );
          //   },
          //   child: Icon(
          //     Icons.wifi,
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> showSosDialog({
    required BuildContext context,
    required void Function(String message) onConfirm,
  }) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),

          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Send SOS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Use this only in case of real emergency. Your location and message will be sent to authorities.",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Describe the emergency (optional)",
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          theme.brightness == Brightness.dark
                              ? AppColors.darkUtilSecondary
                              : AppColors.bgLight,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isInCooldown
                            ? null
                            : () {
                              final message = controller.text.trim();
                              Navigator.pop(context);
                              onConfirm(message);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Send SOS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MapView extends StatelessWidget {
  final MapController mapController;
  final bool isDark;
  final List<Marker> markers;
  final LatLng initialCenter;

  const _MapView({
    required this.mapController,
    required this.isDark,
    required this.markers,
    required this.initialCenter,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🗺 Map widget rebuilt");

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: initialCenter, initialZoom: 13),
      children: [
        TileLayer(
          urlTemplate:
              isDark
                  ? "https://a.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png"
                  : "https://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png",
        ),
        TileLayer(
          tileDisplay: TileDisplay.fadeIn(),
          urlTemplate:
              isDark
                  ? "https://a.basemaps.cartocdn.com/dark_only_labels/{z}/{x}/{y}{r}.png"
                  : "https://a.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}{r}.png",
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

class _SosPulseMarker extends StatefulWidget {
  @override
  State<_SosPulseMarker> createState() => _SosPulseMarkerState();
}

class _SosPulseMarkerState extends State<_SosPulseMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.6);

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.3),
                ),
              ),
            ),
            const Icon(Icons.sos_rounded, color: Colors.red, size: 36),
          ],
        );
      },
    );
  }
}
