import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  TripRepositoryImpl(this.remoteDataSource, this.apiClient);

  @override
  Future<List<dynamic>> getAgencyPlaces(String agencyId) {
    return remoteDataSource.getAgencyPlaces(agencyId);
  }

  /// ✅ Create trip request first
  @override
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
  }) async {
    print("📤 Sending trip request: touristId=$touristId agencyId=$agencyId");

    final response = await apiClient.post('/trip-request/request', {
      'touristId': touristId,
      'agencyId': agencyId,
    });

    print("📥 Trip request response: ${response.data}");

    if (response.statusCode == 200) {
      final requestId =
          response.data['requestId']?.toString() ??
          response.data['data']?['RequestId']?.toString() ??
          '';

      print("✅ Created trip request with ID: $requestId");
      return requestId;
    } else {
      throw Exception('Failed to request trip: ${response.data}');
    }
  }

  /// ✅ Add multiple places to that trip request
  @override
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  }) async {
    print("📤 Sending places for requestId=$requestId: $placeIds");

    final response = await apiClient.post('/trip-request/select-places', {
      'requestId': requestId,
      'placeIds': placeIds,
    });

    print("📥 SelectPlaces response: ${response.data}");

    if (response.statusCode == 200) {
      print("✅ Places successfully linked to trip request $requestId");
    } else {
      throw Exception('Failed to select places: ${response.data}');
    }
  }
}
