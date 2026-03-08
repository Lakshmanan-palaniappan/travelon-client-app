import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';

/// ---------------------------------------------------------------------------
/// GetAgencyPlaces
/// ---------------------------------------------------------------------------
/// Use case for fetching the list of tourist places/attractions 
/// managed by a specific agency.
/// 
/// This is typically called during the trip planning phase when a user 
/// selects an agency and needs to see available destinations.
/// ---------------------------------------------------------------------------
class GetAgencyPlaces {
  final TripRepository repository;

  GetAgencyPlaces(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the use case for the given [agencyId].
  /// 
  /// Returns a [List] of dynamic objects representing the places. 
  /// Usually mapped further in the presentation layer.
  /// -------------------------------------------------------------------------
  Future<List<dynamic>> call(String agencyId) async {
    return await repository.getAgencyPlaces(agencyId);
  }
}