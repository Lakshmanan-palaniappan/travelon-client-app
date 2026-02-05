import '../entities/trip_request.dart';
import '../repositories/my_requests_repository.dart';

class GetMyRequests {
  final MyRequestsRepository repository;

  GetMyRequests(this.repository);

  Future<List<TripRequest>> call() {
    return repository.getMyRequests();
  }
}
