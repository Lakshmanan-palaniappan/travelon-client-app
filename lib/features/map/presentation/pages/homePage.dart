import 'dart:async';

import 'package:Travelon/core/di/injection_container.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/HomeDrawer.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/map/presentation/cubit/gps_cubit.dart';
import 'package:Travelon/features/map/presentation/cubit/wifi_cubit.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:Travelon/features/trip/presentation/prsentatioin/widgets/show_assigned_employee_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Timer? _locationTimer;

  final MapController _mapController = MapController();

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _checkAndStartTracking();
  //   });
  // }

  // void _checkAndStartTracking() {
  //   final tripState = context.read<TripBloc>().state;

  //   if (tripState is AssignedEmployeeLoaded && tripState.employee != null) {
  //     _startLocationTracking();
  //   }
  // }

  // void _startLocationTracking() {
  //   _locationTimer?.cancel(); // safety

  //   // 🔥 CALL IMMEDIATELY ON OPEN
  //   _sendLocation();

  //   // 🔁 CALL EVERY 1 MINUTE
  //   _locationTimer = Timer.periodic(
  //     const Duration(minutes: 1),
  //     (_) => _sendLocation(),
  //   );
  // }

  // void _sendLocation() {
  //   final authState = context.read<AuthBloc>().state;
  //   if (authState is! AuthSuccess) return;

  //   final touristId = int.parse(authState.tourist.id ?? '1');

  //   // 📡 Try Wi-Fi first
  //   context.read<LocationBloc>().add(GetLocationEvent(touristId));
  // }

  // @override
  // void dispose() {
  //   _locationTimer?.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripBloc>().add(FetchCurrentTrip());
    });
  }

  @override
  Widget build(BuildContext context) {
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
              final gpsCubit = context.read<GpsCubit>(); // ✅ FIX
              final wifiCubit = context.read<WifiCubit>();

              if (state is CurrentTripLoaded) {
                if (state.trip.isOngoing) {
                  locationService.start(
                    touristId: state.trip.touristId,
                    getGps: () => gpsCubit.state.location, // ✅ FIX
                    getWifi: () => wifiCubit.state.accessPoints,
                    getAccuracy: () => gpsCubit.state.accuracy, // ✅ FIX
                  );
                } else {
                  locationService.stop();
                }
              }

              if (state is NoCurrentTrip) {
                locationService.stop();
              }
            },
          ),

          /// 📡 WI-FI LOCATION
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationError) {
                ErrorFlash.show(
                  context,
                  title: "Wi-Fi Location Failed",
                  message: "Switching to GPS…",
                );

                context.read<GpsCubit>().fetchCurrentLocation(context);
              }

              if (state is LocationLoaded) {
                _mapController.move(
                  LatLng(state.location.lat, state.location.lng),
                  17,
                );
              }
            },
          ),

          /// 📍 GPS LOCATION
          BlocListener<GpsCubit, GpsState>(
            listener: (context, state) {
              if (state.location != null) {
                _mapController.move(state.location!, 16);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, wifiState) {
                return BlocBuilder<GpsCubit, GpsState>(
                  builder: (context, gpsState) {
                    final markers = <Marker>[];

                    /// GPS Marker
                    if (gpsState.location != null) {
                      markers.add(
                        Marker(
                          width: 80,
                          height: 80,
                          point: gpsState.location!,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                      );
                    }

                    /// Wi-Fi Marker
                    if (wifiState is LocationLoaded) {
                      markers.add(
                        Marker(
                          width: 80,
                          height: 80,
                          point: LatLng(
                            wifiState.location.lat,
                            wifiState.location.lng,
                          ),
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 42,
                          ),
                        ),
                      );
                    }

                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter:
                            gpsState.location ?? const LatLng(10.8505, 76.2711),
                        initialZoom: 13,
                      ),
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
                  },
                );
              },
            ),

            /// ⏳ LOADER (GPS or WIFI)
            BlocBuilder<GpsCubit, GpsState>(
              builder: (context, gps) {
                if (gps.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              },
            ),

            Positioned(bottom: 20, left: 16, child: Text("Travelon")),
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
            Positioned(
              bottom: 150,
              // left: 16,
              right: 16,
              child: BlocListener<TripBloc, TripState>(
                listener: (context, state) {
                  if (state is AssignedEmployeeLoaded) {
                    if (state.employee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No employee assigned yet"),
                        ),
                      );
                      return;
                    }

                    // ✅ OPEN BOTTOM SHEET
                    showAssignedEmployeeSheet(context, state.employee!);
                  }

                  if (state is AssignedEmployeeError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<TripBloc, TripState>(
                  buildWhen:
                      (prev, curr) =>
                          curr is AssignedEmployeeLoading ||
                          curr is AssignedEmployeeLoaded,
                  builder: (context, state) {
                    final isLoading = state is AssignedEmployeeLoading;

                    return FloatingActionButton(
                      // mini: true,
                      shape: const CircleBorder(),
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                context.read<TripBloc>().add(
                                  FetchAssignedEmployee(),
                                );
                              },
                      child: const Icon(Icons.badge_rounded),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              top: 40,
              right: 16,
              child: Builder(
                builder:
                    (context) => Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: IconButton(
                        icon: const Icon(Icons.sos),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            children: [Text("SOS")],
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
                      color: Theme.of(context).colorScheme.surface,
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        // onPressed:
                        //     () => Scaffold.of(context).openDrawer(),
                        onPressed: () {
                          context.push('/menu');
                        },
                      ),
                    ),
              ),
            ),
            Positioned(
              top: 200,
              left: 16,
              child: Builder(
                builder:
                    (context) => Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: Theme.of(context).colorScheme.surface,
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          context.read<TripBloc>().add(FetchCurrentTrip());
                        },
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),

      /// 🔘 ACTION BUTTONS
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// GPS
          FloatingActionButton(
            heroTag: "gps",
            onPressed: () {
              context.read<GpsCubit>().fetchCurrentLocation(context);
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),

          /// WIFI
          FloatingActionButton(
            heroTag: "wifi",
            onPressed: () {
              if (tourist == null) return;
              context.read<LocationBloc>().add(
                GetLocationEvent(int.parse(tourist.id ?? '1')),
              );
            },
            child: const Icon(Icons.wifi),
          ),
        ],
      ),
    );
  }
}
