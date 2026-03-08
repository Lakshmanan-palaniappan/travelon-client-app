import 'package:Travelon/core/network/apiclient.dart';
import '../models/trip_request_model.dart';

/// ---------------------------------------------------------------------------
/// MyRequestsRemoteDataSource
/// ---------------------------------------------------------------------------
/// Abstract contract for fetching trip request data from a remote server.
/// ---------------------------------------------------------------------------
abstract class MyRequestsRemoteDataSource {
  Future<List<TripRequestModel>> getMyRequests();
}

/// ---------------------------------------------------------------------------
/// MyRequestsRemoteDataSourceImpl
/// ---------------------------------------------------------------------------
/// Implementation of [MyRequestsRemoteDataSource] using [ApiClient].
/// 
/// This class interacts directly with the REST API to retrieve the 
/// authenticated user's trip request history.
/// ---------------------------------------------------------------------------
class MyRequestsRemoteDataSourceImpl implements MyRequestsRemoteDataSource {
  final ApiClient apiClient;

  MyRequestsRemoteDataSourceImpl(this.apiClient);

  /// -------------------------------------------------------------------------
  /// getMyRequests
  /// -------------------------------------------------------------------------
  /// Fetches a list of trip requests from the `/trip-request/my-requests` endpoint.
  /// 
  /// Logic:
  /// - Performs a GET request.
  /// - Extracts the 'data' field from the response map.
  /// - Validates that the returned data is a [List].
  /// - Maps each JSON object into a [TripRequestModel].
  /// 
  /// Throws:
  /// - [Exception] if the response format is unexpected.
  /// -------------------------------------------------------------------------
  @override
  Future<List<TripRequestModel>> getMyRequests() async {
    final res = await apiClient.get('/trip-request/my-requests');

    // Extracting nested data based on backend response structure
    final data = res.data['data'];
    
    if (data is! List) {
      throw Exception('Invalid my-requests response format');
    }

    return data
        .map<TripRequestModel>(
          (e) => TripRequestModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}