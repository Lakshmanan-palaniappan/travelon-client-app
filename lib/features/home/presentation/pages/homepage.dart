import 'package:Travelon/core/utils/show_modalsheet.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/HomeDrawer.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/map/presentation/pages/map_view.dart';
import 'package:Travelon/features/map/presentation/widgets/map_fab.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();

  LatLng? currentLocation;
  bool isFetchingLocation = false;

  /// GPS PERMISSION + LOCATION
  Future<void> _getCurrentLocation() async {
    try {
      setState(() => isFetchingLocation = true);

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation =
            LatLng(position.latitude, position.longitude);
        _mapController.move(currentLocation!, 16);
      });
    } finally {
      setState(() => isFetchingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tourist =
        context.watch<AuthBloc>().state is AuthSuccess
            ? (context.read<AuthBloc>().state as AuthSuccess).tourist
            : null;

    return Scaffold(
      drawer: const HomeDrawer(),
      drawerEnableOpenDragGesture: false,

      body: Stack(
        children: [
          MapView(
            mapController: _mapController,
            currentLocation: currentLocation,
          ),

          /// MENU BUTTON
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),

      floatingActionButton: MapFab(
        isGpsLoading: isFetchingLocation,
        onGps: _getCurrentLocation,
        onWifi: () {
          if (tourist == null) return;
          context.read<LocationBloc>().add(
            GetLocationEvent(int.parse(tourist.id ?? '1')),
          );
        },
        onAdd: () {
          if (tourist == null) return;
          _showAddLocationDialog(context, tourist);
        },
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
}
