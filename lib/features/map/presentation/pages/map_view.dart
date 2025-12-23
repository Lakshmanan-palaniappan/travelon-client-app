import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../bloc/location_bloc.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final LatLng? currentLocation;

  const MapView({
    super.key,
    required this.mapController,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          mapController.move(
            LatLng(state.location.lat, state.location.lng),
            17,
          );
        }
      },
      builder: (context, state) {
        final markers = <Marker>[];

        if (currentLocation != null) {
          markers.add(
            Marker(
              width: 80,
              height: 80,
              point: currentLocation!,
              child: const Icon(Icons.my_location, size: 36, color: Colors.blue),
            ),
          );
        }

        if (state is LocationLoaded) {
          markers.add(
            Marker(
              width: 80,
              height: 80,
              point: LatLng(state.location.lat, state.location.lng),
              child: const Icon(Icons.location_pin, size: 42, color: Colors.red),
            ),
          );
        }

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                currentLocation ?? const LatLng(10.8505, 76.2711),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: isDark
                  ? "https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                  : "https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
