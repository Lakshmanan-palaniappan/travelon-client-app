import 'package:Travelon/core/network/apiclient.dart';
import '../models/trip_request_model.dart';

abstract class MyRequestsRemoteDataSource {
  Future<List<TripRequestModel>> getMyRequests();
}

class MyRequestsRemoteDataSourceImpl implements MyRequestsRemoteDataSource {
  final ApiClient apiClient;

  MyRequestsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TripRequestModel>> getMyRequests() async {
    final res = await apiClient.get('/trip-request/my-requests');

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
