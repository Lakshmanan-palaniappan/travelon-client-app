import 'package:Travelon/core/network/apiclient.dart';
import '../../domain/entities/location_result.dart';
import 'location_remote_datasource.dart';

/// ---------------------------------------------------------------------------
/// LocationRemoteDataSourceImpl
/// ---------------------------------------------------------------------------
/// Implementation of [LocationRemoteDataSource] for handling location telemetry.
/// 
/// This class interacts with the trilateration engine on the backend to 
/// calculate and store tourist positions using hybrid signal data.
/// ---------------------------------------------------------------------------
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient apiClient;

  LocationRemoteDataSourceImpl(this.apiClient);

  /// -------------------------------------------------------------------------
  /// getTouristLocation
  /// -------------------------------------------------------------------------
  /// Requests a calculated location from the server based on Wi-Fi fingerprints.
  /// 
  /// Logic:
  /// - POSTs current Wi-Fi access points to the `/trilateration/get-location` endpoint.
  /// - Maps the response to a [LocationResult] entity with lat, lng, and accuracy.
  /// - Ensures coordinates are cast to [double] for mathematical precision.
  /// -------------------------------------------------------------------------
  @override
  Future<LocationResult> getTouristLocation({
    required int touristId,
    required List<Map<String, dynamic>> wifiAccessPoints,
  }) async {
    final response = await apiClient.post('/trilateration/get-location', {
      "touristId": touristId,
      "wifiAccessPoints": wifiAccessPoints,
    });
    
    if (response.statusCode == 200) {
      final data = response.data['data']['location'];
      return LocationResult(
        lat: data['lat'].toDouble(),
        lng: data['lng'].toDouble(),
        accuracy: data['accuracy'].toDouble(),
      );
    } else {
      throw Exception("Failed to get location: ${response.data}");
    }
  }

  /// -------------------------------------------------------------------------
  /// sendLocation
  /// -------------------------------------------------------------------------
  /// Uplinks the user's current raw location data to the backend.
  /// 
  /// Logic:
  /// - Sends optional [gps] and [wifiAccessPoints] maps.
  /// - This is used for background tracking or updating the user's "Last Seen".
  /// -------------------------------------------------------------------------
  @override
  Future<void> sendLocation({
    required int touristId,
    Map<String, dynamic>? gps,
    List<Map<String, dynamic>>? wifiAccessPoints,
  }) async {
    await apiClient.post("/trilateration/set-location", {
      "touristId": touristId,
      "gps": gps,
      "wifiAccessPoints": wifiAccessPoints,
    });
  }
}