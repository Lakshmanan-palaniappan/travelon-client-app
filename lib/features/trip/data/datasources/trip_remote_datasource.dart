import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';

/// ---------------------------------------------------------------------------
/// TripRemoteDataSource
/// ---------------------------------------------------------------------------
/// Handles all remote API calls related to Trips.
///
/// Responsibilities:
/// - Fetch assigned employee for a tourist
/// - Fetch available places from an agency
/// - Create trip requests
/// - Select places for a trip
/// - Fetch tourist trips
///
/// This class communicates with the backend using ApiClient.
/// ---------------------------------------------------------------------------
class TripRemoteDataSource {
  final ApiClient apiClient;

  /// Constructor injection of ApiClient
  TripRemoteDataSource(this.apiClient);

  /// -------------------------------------------------------------------------
  /// Fetch Assigned Employee
  /// -------------------------------------------------------------------------
  /// Retrieves the employee assigned to the current tourist.
  ///
  /// API: GET /assignment/tourist/my-employee
  ///
  /// Returns:
  /// Map containing employee details if successful.
  Future<Map<String, dynamic>?> getAssignedEmployee() async {
    final response = await apiClient.get('/assignment/tourist/my-employee');

    // Validate response format
    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final data = response.data as Map<String, dynamic>;

    // API success response
    if (data['status'] == 'success') {
      return data['data'];
    }

    throw Exception(data['message'] ?? 'Unknown error');
  }

  /// -------------------------------------------------------------------------
  /// Fetch Agency Places
  /// -------------------------------------------------------------------------
  /// Gets all available tourist places for a given agency.
  ///
  /// API: GET /trip/agency/{agencyId}/places
  ///
  /// Returns:
  /// List of places offered by the agency.
  Future<List<dynamic>> getAgencyPlaces(String agencyId) async {
    final response = await apiClient.get('/trip/agency/$agencyId/places');

    if (response.statusCode == 200) {
      final data = response.data;

      // Handle different backend response formats
      if (data is List) return data;
      if (data['data'] is List) return data['data'];
    }

    throw Exception('Failed to load agency places');
  }

  /// -------------------------------------------------------------------------
  /// Create Trip Request
  /// -------------------------------------------------------------------------
  /// Creates a new trip request for a tourist with a specific agency.
  ///
  /// API: POST /trip-request/request
  ///
  /// Returns:
  /// Request ID of the created trip request.
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
  }) async {
    final response = await apiClient.post('/trip-request/request', {
      'touristId': touristId,
      'agencyId': agencyId,
    });

    if (response.statusCode == 200) {
      // Handle different response structures
      final requestId =
          response.data['data']?['RequestId']?.toString() ??
          response.data['RequestId']?.toString() ??
          '';

      return requestId;
    } else {
      throw Exception('Failed to request trip: ${response.data}');
    }
  }

  /// -------------------------------------------------------------------------
  /// Select Places for Trip
  /// -------------------------------------------------------------------------
  /// Adds selected places to an existing trip request.
  ///
  /// API: POST /trip-request/select-places
  ///
  /// Parameters:
  /// - requestId : Trip request ID
  /// - placeIds  : List of selected place IDs
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

  /// -------------------------------------------------------------------------
  /// Fetch Tourist Trips
  /// -------------------------------------------------------------------------
  /// Retrieves all trips associated with a tourist.
  ///
  /// API: GET /trip/tourist/{touristId}
  ///
  /// Returns:
  /// List of TripModel objects.
  Future<List<TripModel>> getTouristTrips(String touristId) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    final data = res.data?['data'];

    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data.map<TripModel>((e) => TripModel.fromJson(e)).toList();
  }

  /// -------------------------------------------------------------------------
  /// Fetch Tourist Trips With Places
  /// -------------------------------------------------------------------------
  /// Retrieves trips along with their associated places.
  ///
  /// Returns:
  /// List of TripWithPlacesModel objects.
  Future<List<TripWithPlacesModel>> getTouristTripsPlaces(
    String touristId,
  ) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    dynamic rawData = res.data;

    // Handle multiple backend response structures
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

  /// -------------------------------------------------------------------------
  /// Generic Trip Fetcher
  /// -------------------------------------------------------------------------
  /// A reusable method to fetch trips and convert them into any model type.
  ///
  /// Example:
  /// getTouristTripsGeneric<TripModel>(touristId, TripModel.fromJson)
  ///
  /// Returns:
  /// List of generic model type T.
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