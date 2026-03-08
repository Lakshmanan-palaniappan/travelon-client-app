import '../entities/location_result.dart';

/// ---------------------------------------------------------------------------
/// LocationRepository
/// ---------------------------------------------------------------------------
/// Abstract contract for location-based operations within the application.
/// 
/// This interface defines the high-level requirement for calculating a 
/// tourist's position, allowing the Domain layer to remain independent 
/// of the underlying positioning hardware or algorithms.
/// ---------------------------------------------------------------------------
abstract class LocationRepository {
  
  /// -------------------------------------------------------------------------
  /// getTouristLocation
  /// -------------------------------------------------------------------------
  /// Triggers a location calculation for the specified [touristId].
  /// 
  /// Returns a [Future] containing a [LocationResult] (lat, lng, and accuracy).
  /// This typically involves gathering local signal data and communicating 
  /// with a remote positioning service.
  /// -------------------------------------------------------------------------
  Future<LocationResult> getTouristLocation(int touristId);
}