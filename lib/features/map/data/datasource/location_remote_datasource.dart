// features/map/data/datasources/location_remote_datasource.dart

import '../../domain/entities/location_result.dart';

abstract class LocationRemoteDataSource {
  Future<LocationResult> getTouristLocation({
    required int touristId,
    required List<Map<String, dynamic>> wifiAccessPoints,
  });

    Future<void> sendLocation({
    required int touristId,
    Map<String, dynamic>? gps,
    List<Map<String, dynamic>>? wifiAccessPoints,
  });
}
