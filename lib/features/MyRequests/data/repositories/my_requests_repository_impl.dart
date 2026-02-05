import '../../domain/entities/trip_request.dart';
import '../../domain/repositories/my_requests_repository.dart';
import '../datasources/my_requests_remote_datasource.dart';

class MyRequestsRepositoryImpl implements MyRequestsRepository {
  final MyRequestsRemoteDataSource remote;

  MyRequestsRepositoryImpl(this.remote);

  @override
  Future<List<TripRequest>> getMyRequests() async {
    return await remote.getMyRequests();
  }
}
