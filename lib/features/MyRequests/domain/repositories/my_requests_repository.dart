import '../entities/trip_request.dart';

/// ---------------------------------------------------------------------------
/// MyRequestsRepository
/// ---------------------------------------------------------------------------
/// Abstract contract for managing and retrieving user trip requests.
/// 
/// This interface resides in the Domain layer to define the data requirements
/// for the "My Requests" feature without being tied to a specific data source.
/// ---------------------------------------------------------------------------
abstract class MyRequestsRepository {
  
  /// -------------------------------------------------------------------------
  /// Retrieves a list of all trip requests submitted by the current tourist.
  /// 
  /// Returns a [Future] containing a list of [TripRequest] entities.
  /// -------------------------------------------------------------------------
  Future<List<TripRequest>> getMyRequests();
}