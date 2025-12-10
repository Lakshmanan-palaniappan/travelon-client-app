import '../entities/location_result.dart';

abstract class LocationRepository {
  Future<LocationResult> getTouristLocation(int touristId);
}
