import 'package:Travelon/features/map/data/datasource/location_remote_datasource.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../domain/entities/location_result.dart';
import '../../domain/repository/location_repository.dart';

/// ---------------------------------------------------------------------------
/// LocationRepositoryImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation of [LocationRepository].
/// 
/// This repository orchestrates the hardware-level Wi-Fi scanning process 
/// required to perform server-side trilateration.
/// ---------------------------------------------------------------------------
class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  /// -------------------------------------------------------------------------
  /// getTouristLocation
  /// -------------------------------------------------------------------------
  /// Triggers a fresh Wi-Fi scan and sends the top signal results to the 
  /// backend to determine the user's coordinates.
  /// 
  /// Workflow:
  /// 1. Verifies/Requests Location Permissions (OS requirement for Wi-Fi scanning).
  /// 2. Initiates a [WiFiScan].
  /// 3. Waits for scan results (3-second buffer).
  /// 4. Extracts the Top 5 strongest Access Points (BSSID + RSSI).
  /// 5. Forwards the data to the [remoteDataSource] for calculation.
  /// -------------------------------------------------------------------------
  @override
  Future<LocationResult> getTouristLocation(int touristId) async {
    // 1. Permission Check
    // Android/iOS require location permissions to access Wi-Fi metadata 
    // to prevent unauthorized tracking.
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      throw Exception("Location permission required for Wi-Fi scan");
    }

    // 2. Hardware Availability Check
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canScan != CanStartScan.yes) {
      throw Exception("Wi-Fi scan not allowed: $canScan");
    }

    // 3. Trigger Scan
    await WiFiScan.instance.startScan();

    // 4. Signal Stabilization
    // A 3-second delay ensures the hardware has time to populate the scan buffer.
    await Future.delayed(const Duration(seconds: 3));

    final results = await WiFiScan.instance.getScannedResults();

    if (results.isEmpty) {
      throw Exception("No Wi-Fi networks found");
    }

    // 5. Data Optimization
    // Selecting the top 5 access points provides enough data for trilateration 
    // while keeping the network payload small.
    final wifiAccessPoints = results
        .take(5)
        .map((n) => {"macAddress": n.bssid, "signalStrength": n.level})
        .toList();

    return await remoteDataSource.getTouristLocation(
      touristId: touristId,
      wifiAccessPoints: wifiAccessPoints,
    );
  }
}