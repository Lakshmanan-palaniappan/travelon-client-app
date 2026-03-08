import '../entities/trip_request.dart';
import '../repositories/my_requests_repository.dart';

/// ---------------------------------------------------------------------------
/// GetMyRequests
/// ---------------------------------------------------------------------------
/// Use case for retrieving the collection of trip requests submitted 
/// by the current user.
/// 
/// This class follows the Command Pattern, providing a single point of entry
/// for the UI/BLoC to trigger the request fetching logic.
/// ---------------------------------------------------------------------------
class GetMyRequests {
  final MyRequestsRepository repository;

  GetMyRequests(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the use case.
  /// 
  /// Returns a [Future] containing a [List] of [TripRequest] entities.
  /// -------------------------------------------------------------------------
  Future<List<TripRequest>> call() {
    return repository.getMyRequests();
  }
}