import 'dart:async';
import 'package:Travelon/features/map/domain/entities/wifi_access_point.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:Travelon/core/network/apiclient.dart';

/// ---------------------------------------------------------------------------
/// LocationSyncService
/// ---------------------------------------------------------------------------
/// A background service responsible for syncing real-time location telemetry.
///
/// This service polls the device's current sensors (GPS/Wi-Fi) at a fixed
/// interval and transmits the data to the trilateration engine.
/// ---------------------------------------------------------------------------
class LocationSyncService {
  final ApiClient apiClient;
  Timer? _timer;

  LocationSyncService(this.apiClient);

  /// -------------------------------------------------------------------------
  /// Starts the synchronization loop.
  ///
  /// Uses a 15-second interval to balance battery efficiency with
  /// tracking accuracy. Replaces any existing active timer.
  /// -------------------------------------------------------------------------
  void start({
    required int touristId,
    required LatLng? Function() getGps,
    required List<WifiAccessPoint> Function() getWifi,
    required double Function() getAccuracy,
  }) {
    stop(); // Ensure singleton-like behavior for the timer
    _send(touristId, getGps, getWifi, getAccuracy);

    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _send(touristId, getGps, getWifi, getAccuracy),
    );
  }

  /// -------------------------------------------------------------------------
  /// Internal logic for payload construction and API transmission.
  /// -------------------------------------------------------------------------
  Future<void> _send(
    int touristId,
    LatLng? Function() getGps,
    List<WifiAccessPoint> Function() getWifi,
    double Function() getAccuracy,
  ) async {
    final gps = getGps();
    if (gps == null) return; // Silent return if GPS lock is lost

    final payload = {
      "touristId": touristId,
      "wifiAccessPoints":
          getWifi()
              .map((w) => {"macAddress": w.bssid, "signalStrength": w.level})
              .toList(),
      "gps": {
        "lat": gps.latitude,
        "lng": gps.longitude,
        "accuracy": getAccuracy().round(),
      },
    };

    // Transmits to the set-location endpoint
    final res = await apiClient.post("/trilateration/set-location", payload);

    // Geofencing Logic
    // Inspects the response for immediate server-side geofence validation.
    final data = res.data;
    final geofence = data?['data']?['geofence'];

    if (geofence != null && geofence['isInsideGeofence'] == true) {
      // Note: This is where you would trigger a BLoC event or notification
    }
  }

  /// -------------------------------------------------------------------------
  /// Stops the synchronization loop and releases the timer resources.
  /// -------------------------------------------------------------------------
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
