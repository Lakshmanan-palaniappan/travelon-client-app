import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/HomeDrawer.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final MapController _mapController = MapController();

  LatLng? currentLocation;
  bool isFetchingLocation = false;

  /// 📍 MANUAL GPS LOCATION FETCH
  Future<void> _getCurrentLocation() async {
    try {
      setState(() => isFetchingLocation = true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(currentLocation!, 16);
      });
    } catch (e) {
      ErrorFlash.show(
        context,
        title: "GPS Error",
        message: "Failed to get current location",
      );
    } finally {
      setState(() => isFetchingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final tourist = authState is AuthSuccess ? authState.tourist : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const HomeDrawer(),
      drawerEnableOpenDragGesture: false,

      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ErrorFlash.show(
              context,
              title: "Location Failed",
              message:
                  "Unable to fetch your current location. Please try again.",
            );
          }

          if (state is LocationLoaded) {
            _mapController.move(
              LatLng(state.location.lat, state.location.lng),
              17,
            );
          }
        },
        builder: (context, state) {
          final markers = <Marker>[];

          /// 📍 GPS Marker
          if (currentLocation != null) {
            markers.add(
              Marker(
                width: 80,
                height: 80,
                point: currentLocation!,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 36,
                ),
              ),
            );
          }

          /// 📡 Wi-Fi Marker
          if (state is LocationLoaded) {
            markers.add(
              Marker(
                width: 80,
                height: 80,
                point: LatLng(state.location.lat, state.location.lng),
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 42,
                ),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      currentLocation ?? const LatLng(10.8505, 76.2711),
                  initialZoom: 13,
                ),
                children: [
                  // ───── BASE MAP (NO LABELS) ─────
                  // 🌍 Base (no labels)
                  TileLayer(
                    urlTemplate:
                        isDark
                            ? "https://a.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png"
                            : "https://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png",
                  ),

                  // 🏷️ Labels (softened)
                  TileLayer(
                    tileDisplay: TileDisplay.fadeIn(),
                    urlTemplate:
                        isDark
                            ? "https://a.basemaps.cartocdn.com/dark_only_labels/{z}/{x}/{y}{r}.png"
                            : "https://a.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}{r}.png",
                    // 🔥 KEY CHANGE
                  ),

                  MarkerLayer(markers: markers),
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
                              icon: const Icon(Icons.menu),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                            ),
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

                  Positioned(bottom: 20, left: 16, child: Text("Travelon")),
                ],
              ),

              /// ⏳ GPS Loader
              if (isFetchingLocation)
                const Center(child: CircularProgressIndicator()),

              /// ⏳ Wi-Fi Loader
              if (state is LocationLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),

      /// 🔘 ACTION BUTTONS
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "gps",
            shape: const CircleBorder(),
            // mini: true,
            onPressed: isFetchingLocation ? null : _getCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),

          FloatingActionButton(
            heroTag: "wifi",
            // mini: true,
            shape: const CircleBorder(),
            onPressed: () {
              if (tourist == null) return;
              context.read<LocationBloc>().add(
                GetLocationEvent(int.parse(tourist.id ?? '1')),
              );
            },
            child: const Icon(Icons.wifi),
          ),
          const SizedBox(height: 12),

          // FloatingActionButton(
          //   heroTag: "add",
          //   shape: const CircleBorder(),
          //   onPressed: () {
          //     if (tourist == null) return;
          //     _showAddLocationDialog(context, tourist);
          //   },
          //   child: const Icon(Icons.add),
          // ),
        ],
      ),
    );
  }

 
}
