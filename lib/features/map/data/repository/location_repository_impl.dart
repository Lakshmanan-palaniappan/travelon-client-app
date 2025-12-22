// features/map/data/repositories/location_repository_impl.dart

import 'package:Travelon/features/map/data/datasource/location_remote_datasource.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../domain/entities/location_result.dart';
import '../../domain/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<LocationResult> getTouristLocation(int touristId) async {
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canScan != CanStartScan.yes) {
      throw Exception("Wi-Fi scan not allowed: $canScan");
    }

    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();
    if (results.isEmpty) {
      throw Exception("No Wi-Fi networks found");
    }

    final wifiAccessPoints =
        results
            .take(5)
            .map((n) => {"macAddress": n.bssid, "signalStrength": n.level})
            .toList();

    return await remoteDataSource.getTouristLocation(
      touristId: touristId,
      wifiAccessPoints: wifiAccessPoints,
    );
  }
}
