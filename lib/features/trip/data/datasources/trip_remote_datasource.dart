import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';

class TripRemoteDataSource {
  final ApiClient apiClient;

  TripRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>?> getAssignedEmployee() async {
    final response = await apiClient.get('/assignment/tourist/my-employee');

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final data = response.data as Map<String, dynamic>;


    if (data['status'] == 'success') {
      return data['data'];
    }

    throw Exception(data['message'] ?? 'Unknown error');
  }

  Future<List<dynamic>> getAgencyPlaces(String agencyId) async {
    final response = await apiClient.get('/trip/agency/$agencyId/places');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List) return data;
      if (data['data'] is List) return data['data'];
    }
    throw Exception('Failed to load agency places');
  }

  /// Create Trip Request
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
  }) async {
    final response = await apiClient.post('/trip-request/request', {
      'touristId': touristId,
      'agencyId': agencyId,
    });


    if (response.statusCode == 200) {
      // Handle nested + capitalized key
      final requestId =
          response.data['data']?['RequestId']?.toString() ??
          response.data['RequestId']?.toString() ??
          '';

      return requestId;
    } else {
      throw Exception('Failed to request trip: ${response.data}');
    }
  }


  /// Add Places to That Trip
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  }) async {
    final response = await apiClient.post('/trip-request/select-places', {
      'requestId': requestId,
      'placeIds': placeIds,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to select places: ${response.data}');
    }
  }

  Future<List<TripModel>> getTouristTrips(String touristId) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    final data = res.data?['data'];

    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data.map<TripModel>((e) => TripModel.fromJson(e)).toList();
  }

  

  Future<List<TripWithPlacesModel>> getTouristTripsPlaces(
    String touristId,
  ) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    dynamic rawData = res.data;

    final List<dynamic> listData =
        (rawData is Map && rawData.containsKey('data'))
            ? rawData['data']
            : (rawData is List ? rawData : []);


    if (listData.isEmpty) {
      return [];
    }

    return listData
        .map<TripWithPlacesModel>(
          (e) => TripWithPlacesModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<T>> getTouristTripsGeneric<T>(
    String touristId,
    T Function(Map<String, dynamic>) fromJson,
  ) async {

    final res = await apiClient.get('/trip/tourist/$touristId');

    final data = res.data?['data'];

    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data.map<T>((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
