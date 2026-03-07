import 'dart:async';
import 'package:Travelon/features/map/domain/entities/wifi_access_point.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:Travelon/core/network/apiclient.dart';



class LocationSyncService {
  final ApiClient apiClient;
  Timer? _timer;

  LocationSyncService(this.apiClient);

  void start({
    required int touristId,
    required LatLng? Function() getGps,
    required List<WifiAccessPoint> Function() getWifi,
    required double Function() getAccuracy,
  }) {
    stop();
    _send(touristId, getGps, getWifi, getAccuracy);

    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _send(touristId, getGps, getWifi, getAccuracy),
    );
  }

  Future<void> _send(
    int touristId,
    LatLng? Function() getGps,
    List<WifiAccessPoint> Function() getWifi,
    double Function() getAccuracy,
  ) async {
    final gps = getGps();
    if (gps == null) return;

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
    final res = await apiClient.post("/trilateration/set-location", payload);

    final data = res.data;
    final geofence = data?['data']?['geofence'];

    if (geofence != null && geofence['isInsideGeofence'] == true) {
      debugPrint("🚨 GEOFENCE BREACH (HTTP): $geofence");
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
