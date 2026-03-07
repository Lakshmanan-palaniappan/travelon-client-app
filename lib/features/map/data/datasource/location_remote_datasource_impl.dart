
import 'package:Travelon/core/network/apiclient.dart';
import '../../domain/entities/location_result.dart';
import 'location_remote_datasource.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient apiClient;

  LocationRemoteDataSourceImpl(this.apiClient);

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
