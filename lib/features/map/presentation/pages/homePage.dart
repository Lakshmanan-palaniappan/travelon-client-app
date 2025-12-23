import 'package:Travelon/core/utils/show_modalsheet.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/HomeDrawer.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   title: Text('HomePage', style: Theme.of(context).textTheme.titleLarge),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout_outlined),
      //       onPressed: () => _confirmLogout(context),
      //     ),
      //   ],
      // ),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(0),
      //   child: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      // ),
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

          FloatingActionButton(
            heroTag: "add",
            shape: const CircleBorder(),
            onPressed: () {
              if (tourist == null) return;
              _showAddLocationDialog(context, tourist);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddLocationDialog(
    BuildContext context,
    Tourist tourist,
  ) async {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            /// 📅 Date Picker
            Future<void> _pickDate(
              TextEditingController controller,
              String label,
            ) async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                helpText: label,
              );

              if (picked != null) {
                controller.text =
                    "${picked.day.toString().padLeft(2, '0')}/"
                    "${picked.month.toString().padLeft(2, '0')}/"
                    "${picked.year}";

                setDialogState(() {}); // 🔥 FORCE REBUILD
              }
            }

            final theme = Theme.of(context);

            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              // ───── TITLE ─────
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Request Trip",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select your travel dates",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // ───── CONTENT ─────
              contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              content: SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.9, // 🔥 wider dialog
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      myReadonlyField(
                        context: context,
                        hintText: "Agency ID",
                        value: tourist.agencyId.toString(),
                        icon: Icons.apartment_outlined,
                      ),

                      myReadonlyField(
                        context: context,
                        hintText: "Tourist ID",
                        value: tourist.id.toString(),
                        icon: Icons.badge_outlined,
                      ),

                      const SizedBox(height: 16),

                      dateTile(
                        context: context,
                        hintText: "Start Date",
                        controller: startDateController,
                        onTap:
                            () => _pickDate(
                              startDateController,
                              "Select Start Date",
                            ),
                      ),

                      dateTile(
                        context: context,
                        hintText: "End Date",
                        controller: endDateController,
                        onTap:
                            () =>
                                _pickDate(endDateController, "Select End Date"),
                      ),
                    ],
                  ),
                ),
              ),

              // ───── ACTION ─────
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              actions: [
                BlocConsumer<TripBloc, TripState>(
                  listener: (context, state) {
                    if (state is TripRequestSuccess) {
                      
                      Navigator.pop(context);
                      showPlacesModal(
                        context,
                        tourist.agencyId,
                        int.parse(tourist.id ?? '0'),
                      );
                    }

                    if (state is TripRequestError) {
                      ErrorFlash.show(context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is TripLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MyElevatedButton(
                        radius: 30,
                        text: isLoading ? "Requesting..." : "Continue",
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (startDateController.text.isEmpty ||
                                      endDateController.text.isEmpty) {
                                    ErrorFlash.show(
                                      context,
                                      message:
                                          "Please select both start and end dates",
                                    );
                                    return;
                                  }

                                  context.read<TripBloc>().add(
                                    SubmitTripRequest(
                                      touristId: tourist.id.toString(),
                                      agencyId: tourist.agencyId.toString(),
                                      startDate: startDateController.text,
                                      endDate: endDateController.text,
                                    ),
                                  );
                                },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }






  Widget myReadonlyField({
    required BuildContext context,
    required String hintText,
    required String value,
    required IconData icon,
    double radius = 12,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value, // ✅ NO controller recreation
        enabled: false,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          filled: true,
          fillColor: scheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(width: 1.0, color: scheme.onPrimary),
          ),
        ),
      ),
    );
  }

  Widget dateTile({
    required BuildContext context,
    required String hintText,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasValue = controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.calendar_today, color: scheme.primary),
            filled: true,
            fillColor: scheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 1.0, color: scheme.onPrimary),
            ),
          ),
          child: Text(
            hasValue ? controller.text : hintText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: hasValue ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  /// 🚪 LOGOUT
  Future<bool> _confirmLogout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();

    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authBloc.add(LogoutEvent());
                      context.go('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
