import 'package:flutter/material.dart';

class MapFab extends StatelessWidget {
  final VoidCallback onGps;
  final VoidCallback onWifi;
  final VoidCallback onAdd;
  final bool isGpsLoading;

  const MapFab({
    super.key,
    required this.onGps,
    required this.onWifi,
    required this.onAdd,
    required this.isGpsLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "gps",
          onPressed: isGpsLoading ? null : onGps,
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 12),

        FloatingActionButton(
          heroTag: "wifi",
          onPressed: onWifi,
          child: const Icon(Icons.wifi),
        ),
        const SizedBox(height: 12),

        FloatingActionButton(
          heroTag: "add",
          onPressed: onAdd,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
