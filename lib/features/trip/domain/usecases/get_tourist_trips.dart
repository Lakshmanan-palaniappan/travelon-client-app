import '../entities/trip.dart';
import '../repository/trip_repository.dart';

/// ---------------------------------------------------------------------------
/// GetTouristTrips
/// ---------------------------------------------------------------------------
/// Use case for retrieving a history of trips associated with a specific tourist.
/// 
/// This class encapsulates the logic for fetching all trip records through 
/// the [TripRepository], typically used for "My Trips" or "Travel History" screens.
/// ---------------------------------------------------------------------------
class GetTouristTrips {
  final TripRepository repository;

  GetTouristTrips(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the use case for the given [touristId].
  /// 
  /// Returns a [List] of [Trip] entities, providing core metadata 
  /// for each recorded trip.
  /// -------------------------------------------------------------------------
  Future<List<Trip>> call(String touristId) {
    return repository.getTouristTrips(touristId);
  }
}