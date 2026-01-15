import 'dart:async';
import 'package:Travelon/features/map/domain/entities/wifi_access_point.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:Travelon/core/network/apiclient.dart';

// class WifiAccessPoint {
//   final String bssid;
//   final int level;

//   WifiAccessPoint({required this.bssid, required this.level});
// }

// class LocationSyncService {
//   final ApiClient apiClient;
//   final TripRepository tripRepository;
//   Timer? _timer;

//   LocationSyncService(this.apiClient, this.tripRepository);

//   void start({
//     required int touristId,
//     required LatLng? Function() getGps,
//     required List<WifiAccessPoint> Function() getWifi,
//     required double Function() getAccuracy,
//   }) {
//     stop();
//     _send(touristId, getGps, getWifi, getAccuracy);
//     _timer = Timer.periodic(
//       const Duration(minutes: 1),
//       (_) => _send(touristId, getGps, getWifi, getAccuracy),
//     );
//   }

//   Future<void> _send(
//     int touristId,
//     LatLng? Function() getGps,
//     List<WifiAccessPoint> Function() getWifi,
//     double Function() getAccuracy,
//   ) async {
//     try {
//       final gps = getGps();
//       if (gps == null) {
//         debugPrint("📍 GPS null, skipping send");
//         return;
//       }

//       final wifiList = getWifi();

//       final payload = {
//         "touristId": touristId,
//         "wifiAccessPoints": wifiList
//             .map((w) => {
//                   "macAddress": w.bssid,
//                   "signalStrength": w.level,
//                 })
//             .toList(),
//         "gps": {
//           "lat": gps.latitude,
//           "lng": gps.longitude,
//           "accuracy": getAccuracy().round(),
//         },
//       };

//       debugPrint("📡 Sending location payload => $payload");

//       await apiClient.post("/set-location", payload);

//       debugPrint("✅ Location sent successfully");
//     } catch (e, stack) {
//       debugPrint("❌ Location send failed: $e");
//       debugPrint(stack.toString());
//     }
//   }

// old old

// void start({
//   required int touristId,
//   required LatLng? Function() getGps,
//   required List Function() getWifi,
// }) {
//   stop();
//   _send(touristId, getGps, getWifi);
//   _timer = Timer.periodic(
//     const Duration(minutes: 1),
//     (_) => _send(touristId, getGps, getWifi),
//   );
// }
// void _send(
//   int touristId,
//   LatLng? Function() getGps,
//   List getWifi,
// ) async {
//   try {
//     final gps = getGps();
//     if (gps == null) {
//       debugPrint("📍 GPS null, skipping send");
//       return;
//     }

//     final wifiList = getWifi();

//     final payload = {
//       "touristId": touristId,
//       "wifiAccessPoints": wifiList.map((w) => {
//         "macAddress": w.bssid,
//         "signalStrength": w.level,
//       }).toList(),
//       "gps": {
//         "lat": gps.latitude,
//         "lng": gps.longitude,
//       },
//     };

//     debugPrint("📡 Sending location payload => $payload");
//     await apiClient.post("/trilateration/set-location", payload);
//   } catch (e) {
//     debugPrint("❌ Location send failed: $e");
//   }
// }

// old
//   void stop() {
//     _timer?.cancel();
//     _timer = null;
//   }

//   Future<void> syncBasedOnTrip({
//     required int touristId,
//     required LatLng? Function() getGps,
//     required List<WifiAccessPoint> Function() getWifi,
//     required double Function() getAccuracy,
//   }) async {
//     final trip = await tripRepository.getCurrentTrip();

//     if (trip == null || !trip.isOngoing) {
//       debugPrint("🚫 Trip not ongoing → stopping location sync");
//       stop();
//       return;
//     }

//     debugPrint("✅ Trip ongoing → starting location sync");
//     start(
//       touristId: touristId,
//       getGps: getGps,
//       getWifi: getWifi,
//       getAccuracy: getAccuracy,
//     );
//   }
// }

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
      const Duration(minutes: 1),
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
    debugPrint("👉 Location is being transmitted");
    debugPrint("👉 payload $payload");
    final res = await apiClient.post("/trilateration/set-location", payload);
    debugPrint("✅ Location sent");
    debugPrint("📥 Server response => $res");
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
