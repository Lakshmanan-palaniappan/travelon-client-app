import 'dart:async';

import 'package:Travelon/core/di/injection_container.dart';
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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Timer? _locationTimer;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1️⃣ Fetch trip status
      context.read<TripBloc>().add(FetchCurrentTrip());

      // 2️⃣ Fetch GPS immediately
      context.read<GpsCubit>().fetchCurrentLocation(context);

      // 3️⃣ Fetch Wi-Fi immediately
      final auth = context.read<AuthBloc>().state;
      if (auth is AuthSuccess) {
        context.read<LocationBloc>().add(
          GetLocationEvent(int.parse(auth.tourist.id!)),
        );
      }
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

              // !!!!!!!!! Location sending logic Disabled for debugging !!!!!!!!!!!!!!
              // if (state is CurrentTripLoaded) {
              //   if (state.trip.isOngoing) {
              //     locationService.start(
              //       touristId: state.trip.touristId,
              //       getGps: () => gpsCubit.state.location, // ✅ FIX
              //       getWifi: () => wifiCubit.state.accessPoints,
              //       getAccuracy: () => gpsCubit.state.accuracy, // ✅ FIX
              //     );

              //     context.read<TripBloc>().add(FetchAssignedEmployee());
              //   } else {
              //     locationService.stop();
              //   }
              // }

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
                  return const Center(child: Myloader());
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
              right: 16,
              child: BlocBuilder<TripBloc, TripState>(
                buildWhen:
                    (prev, curr) =>
                        curr is AssignedEmployeeLoaded ||
                        curr is AssignedEmployeeLoading ||
                        curr is AssignedEmployeeError,
                builder: (context, state) {
                  // ❌ No employee → don't show button
                  if (state is! AssignedEmployeeLoaded ||
                      state.employee == null) {
                    print("employee not assigned");
                    return const SizedBox.shrink();
                  }

                  return FloatingActionButton(
                    heroTag: "employee",
                    shape: const CircleBorder(),
                    onPressed: () {
                      // showAssignedEmployeeSheet(context, state.employee!);
                      showEmployeePopup(context, state.employee!);
                    },
                    child: const Icon(Icons.badge_rounded),
                  );
                },
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
                          showSosDialog(
                            context: context,
                            onConfirm: (userMessage) {
                              final gps = context.read<GpsCubit>().state;
                              final wifi = context.read<WifiCubit>().state;

                              final hasGps = gps.location != null;
                              final hasWifi = wifi.accessPoints.isNotEmpty;

                              if (!hasGps && !hasWifi) {
                                ErrorFlash.show(
                                  context,
                                  message: "Unable to get location. Try again.",
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
                                            "signalStrength": ap.level,
                                          },
                                        )
                                        .toList(),
                                message: message,
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

  Future<void> showSosDialog({
    required BuildContext context,
    required void Function(String message) onConfirm,
  }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send SOS"),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Describe the emergency (optional)",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final message = controller.text.trim();
                Navigator.pop(context);
                onConfirm(message);
              },
              child: const Text("Send SOS"),
            ),
          ],
        );
      },
    );
  }
}
