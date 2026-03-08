import '../../domain/entities/trip_request.dart';
import '../../domain/repositories/my_requests_repository.dart';
import '../datasources/my_requests_remote_datasource.dart';

/// ---------------------------------------------------------------------------
/// MyRequestsRepositoryImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation of [MyRequestsRepository].
/// 
/// This class orchestrates the flow of data from the [MyRequestsRemoteDataSource]
/// to the Domain layer, ensuring that the UI receives pure [TripRequest] entities.
/// ---------------------------------------------------------------------------
class MyRequestsRepositoryImpl implements MyRequestsRepository {
  final MyRequestsRemoteDataSource remote;

  MyRequestsRepositoryImpl(this.remote);

  /// -------------------------------------------------------------------------
  /// getMyRequests
  /// -------------------------------------------------------------------------
  /// Bridges the call to the remote data source to fetch user trip requests.
  /// 
  /// Logic:
  /// - Invokes the [remote.getMyRequests] method.
  /// - Returns the resulting list of models as domain [TripRequest] entities.
  /// -------------------------------------------------------------------------
  @override
  Future<List<TripRequest>> getMyRequests() async {
    return await remote.getMyRequests();
  }
}