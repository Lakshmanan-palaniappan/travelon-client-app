import '../../domain/entities/location_result.dart';

/// ---------------------------------------------------------------------------
/// LocationRemoteDataSource
/// ---------------------------------------------------------------------------
/// Abstract contract for managing remote location data operations.
/// 
/// This interface defines how the application interacts with the 
/// backend trilateration and tracking services.
/// ---------------------------------------------------------------------------
abstract class LocationRemoteDataSource {
  
  /// -------------------------------------------------------------------------
  /// getTouristLocation
  /// -------------------------------------------------------------------------
  /// Requests the server to calculate a tourist's precise location.
  /// 
  /// Uses [wifiAccessPoints] to perform server-side trilateration.
  /// Returns a [LocationResult] containing coordinates and accuracy metadata.
  /// -------------------------------------------------------------------------
  Future<LocationResult> getTouristLocation({
    required int touristId,
    required List<Map<String, dynamic>> wifiAccessPoints,
  });

  /// -------------------------------------------------------------------------
  /// sendLocation
  /// -------------------------------------------------------------------------
  /// Uplinks raw telemetry data to the server for tracking purposes.
  /// 
  /// Parameters:
  /// - [gps]: Precise latitude/longitude from the device's GPS hardware.
  /// - [wifiAccessPoints]: A list of nearby BSSIDs and signal strengths.
  /// 
  /// Allows the backend to maintain an up-to-date position for the user.
  /// -------------------------------------------------------------------------
  Future<void> sendLocation({
    required int touristId,
    Map<String, dynamic>? gps,
    List<Map<String, dynamic>>? wifiAccessPoints,
  });
}