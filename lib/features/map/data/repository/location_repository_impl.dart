import 'dart:convert';
import 'package:Travelon/features/map/domain/repository/location_repository.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_scan/wifi_scan.dart';
import '../../domain/entities/location_result.dart';

class LocationRepositoryImpl implements LocationRepository {
  final String baseUrl;

  LocationRepositoryImpl(this.baseUrl);

  @override
  Future<LocationResult> getTouristLocation(int touristId) async {
    // Step 1: Scan Wi-Fi
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canScan != CanStartScan.yes) {
      throw Exception("Wi-Fi scan not allowed: $canScan");
    }

    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();
    if (results.isEmpty) throw Exception("No Wi-Fi networks found");

    // Step 2: Prepare data
    final wifiAccessPoints = results.take(5).map((n) => {
      "macAddress": n.bssid,
      "signalStrength": n.level,
    }).toList();

    final body = jsonEncode({
      "touristId": touristId,
      "wifiAccessPoints": wifiAccessPoints,
    });

    // Step 3: Send to backend
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["data"]["location"];
      return LocationResult(
        lat: data["lat"].toDouble(),
        lng: data["lng"].toDouble(),
        accuracy: data["accuracy"].toDouble(),
      );
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }
}
