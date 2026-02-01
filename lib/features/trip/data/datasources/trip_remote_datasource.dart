import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:Travelon/features/trip/domain/entities/trip_with_places.dart';

class TripRemoteDataSource {
  final ApiClient apiClient;

  TripRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>?> getAssignedEmployee() async {
    print("going to call employee api");
    final response = await apiClient.get('/assignment/tourist/my-employee');
    print("reasponse code : ${response.statusCode}");
    print("after call employee api");

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final data = response.data as Map<String, dynamic>;

    print(data.toString());

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

  /// ✅ 1️⃣ Create Trip Request
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
  }) async {
    final response = await apiClient.post('/trip-request/request', {
      'touristId': touristId,
      'agencyId': agencyId,
    });

    print("📥 Trip request response: ${response.data}");

    if (response.statusCode == 200) {
      // Handle nested + capitalized key
      final requestId =
          response.data['data']?['RequestId']?.toString() ??
          response.data['RequestId']?.toString() ??
          '';

      print("✅ Created trip request with ID: $requestId");
      return requestId;
    } else {
      throw Exception('Failed to request trip: ${response.data}');
    }
  }

  /// ✅ 2️⃣ Add Places to That Trip
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
    print(">?>>>>?>?>>?>?>? $touristId");
    final res = await apiClient.get('/trip/tourist/$touristId');
    // final res = await apiClient.get('/trip-request/my-requests/$touristId');

    if (res.statusCode == 200) {
      print("OKay bro ><><><><><><><>>");
    }

    final data = res.data?['data'];

    print("gettouristtrips: ${data}");

    print(">?>>>>?>?>>?>?>?");

    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data.map<TripModel>((e) => TripModel.fromJson(e)).toList();
  }

  // Future<List<TripWithPlacesModel>> getTouristTripsPlaces(
  //   String touristId,
  // ) async {
  //   final res = await apiClient.get('/trip/tourist/$touristId');

  //   print("Status code : ${res.statusCode}");
  //   final data = res.data?['data'];

  //   print("tripwithplacesmodel  here bro");
  //   print(data.toString());
  //   if (data is! List) {
  //     throw Exception('Invalid trips response');
  //   }

  //   return data
  //       .map<TripWithPlacesModel>((e) => TripWithPlacesModel.fromJson(e))
  //       .toList();
  // }

  Future<List<TripWithPlacesModel>> getTouristTripsPlaces(
    String touristId,
  ) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    // 1. Determine where the list is.
    // If the log shows [{...}], then res.data is likely already the List.
    dynamic rawData = res.data;

    // If your API wraps it in a 'data' field, extract it.
    // Otherwise, use res.data directly.
    final List<dynamic> listData =
        (rawData is Map && rawData.containsKey('data'))
            ? rawData['data']
            : (rawData is List ? rawData : []);

    print("Found ${listData.length} trips in response");

    if (listData.isEmpty) {
      print("Warning: No trips found or data format mismatch");
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
    print("Fetching trips for touristId: $touristId");

    final res = await apiClient.get('/trip/tourist/$touristId');

    if (res.statusCode == 200) {
      print("Request successful!");
    }

    final data = res.data?['data'];
    print(data);

    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data.map<T>((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
