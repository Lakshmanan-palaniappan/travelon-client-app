import '../entities/trip_request.dart';

abstract class MyRequestsRepository {
  Future<List<TripRequest>> getMyRequests();
}
