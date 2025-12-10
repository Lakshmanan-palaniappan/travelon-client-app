import 'package:Travelon/core/show_modalsheet.dart';
import 'package:Travelon/core/utils/widgets/ErrorCard.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' hide MapController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final MapController _mapController = MapController();
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Get device GPS location for map initialization
  Future<void> _getCurrentLocation() async {
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
      _mapController.move(currentLocation!, 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final tourist = authState is AuthSuccess ? authState.tourist : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wi-Fi Trilateration Map',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Archivo'),
        ),
      ),

      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoaded) {
            final newPoint = LatLng(state.location.lat, state.location.lng);
            _mapController.move(newPoint, 17.0);
          }
        },
        builder: (context, state) {
          final markers = <Marker>[];

          // ✅ Show GPS marker
          if (currentLocation != null) {
            markers.add(
              Marker(
                width: 80,
                height: 80,
                point: currentLocation!,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
            );
          }

          // ✅ Show Wi-Fi trilateration location marker
          if (state is LocationLoaded) {
            markers.add(
              Marker(
                width: 80,
                height: 80,
                point: LatLng(state.location.lat, state.location.lng),
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLocation ?? LatLng(10.8505, 76.2711),
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),

              // ✅ Show progress loader during Wi-Fi scan
              if (state is LocationLoading)
                const Center(child: CircularProgressIndicator()),

              // ✅ Show error message
              if (state is LocationError)
                Center(
                  child: Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

              // ✅ Optional: show info overlay for accuracy
              if (state is LocationLoaded)
                Positioned(
                  bottom: 100,
                  left: 10,
                  right: 10,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Estimated Wi-Fi Location",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Lat: ${state.location.lat.toStringAsFixed(6)}, "
                            "Lng: ${state.location.lng.toStringAsFixed(6)}",
                          ),
                          Text(
                            "Accuracy: ±${state.location.accuracy.toStringAsFixed(1)} m",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.wifi),
        label: const Text("Scan Wi-Fi Location"),
        onPressed: () {
          if (tourist == null) return;
          context.read<LocationBloc>().add(
            GetLocationEvent(int.parse(tourist.id ?? '1')),
          );
        },
      ),
    );
  }

  Future<void> _showAddLocationDialog(
    BuildContext context,
    Tourist? tourist,
  ) async {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

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
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              'Add Location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tourist!.agencyId.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Agency ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: tourist!.id.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tourist ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap:
                        () =>
                            _pickDate(startDateController, "Select Start Date"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap:
                        () => _pickDate(endDateController, "Select End Date"),
                  ),
                ],
              ),
            ),
            actions: [
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 32,
              //       vertical: 12,
              //     ),
              //   ),
              //   onPressed: () {
              //     if (startDateController.text.isEmpty ||
              //         endDateController.text.isEmpty) {
              //       showErrorFlash(
              //         context,
              //         "Please select both start and end dates",
              //       );
              //       return;
              //     }
              //     // TODO: handle submission of the dates
              //     Navigator.pop(context);
              //   },
              //   child: const Text("Next"),
              // ),
              Myelevatedbutton(
                show_text: "Next",
                onPressed: () {
                  if (startDateController.text.isEmpty ||
                      endDateController.text.isEmpty) {
                    showErrorFlash(
                      context,
                      "Please select both start and end dates",
                    );
                    return;
                  }
                  // TODO: handle submission of the dates
                  Navigator.pop(context);
                  // ✅ Open bottom sheet
                  // showModalBottomSheet(
                  //   useSafeArea: true,
                  //   context: context,
                  //   isScrollControlled: true,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(20),
                  //     ),
                  //   ),
                  //   builder: (context) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(
                  //         bottom: MediaQuery.of(context).viewInsets.bottom,
                  //         top: 20,
                  //         left: 20,
                  //         right: 20,
                  //       ),
                  //       child: Container(
                  //         width: double.infinity,
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text(
                  //               'Dates Selected',
                  //               style: Theme.of(context).textTheme.bodyMedium,
                  //             ),
                  //             const SizedBox(height: 12),
                  //             Text('Start: ${startDateController.text}'),
                  //             Text('End: ${endDateController.text}'),
                  //             const SizedBox(height: 20),
                  //             ElevatedButton(
                  //               onPressed: () => Navigator.pop(context),
                  //               child: const Text('Close'),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );

                  // final tourist = context.read<AuthBloc>().state.tourist!;
                  showPlacesModal(
                    context,
                    tourist.agencyId,
                    int.parse(tourist.id ?? '0'),
                  );
                },
                radius: 50.0,
              ),
            ],
          ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
