import '../entities/trip.dart';
import '../repository/trip_repository.dart';

class GetTouristTrips {
  final TripRepository repository;

  GetTouristTrips(this.repository);

  Future<List<Trip>> call(String touristId) {
    return repository.getTouristTrips(touristId);
  }
}
