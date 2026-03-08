import '../entities/agency.dart';
import '../repositories/agency_repository.dart';

/// ---------------------------------------------------------------------------
/// GetAgencyDetails
/// ---------------------------------------------------------------------------
/// A Use Case responsible for retrieving comprehensive data for one agency.
/// 
/// This class acts as a single-purpose command that bridges the 
/// Presentation layer (UI/BLoC) with the Data layer (Repository) 
/// to fetch a specific agency profile by its unique identifier.
/// ---------------------------------------------------------------------------
class GetAgencyDetails {
  final AgencyRepository repository;

  GetAgencyDetails(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the retrieval request.
  /// 
  /// Parameters:
  /// - [id]: The unique numeric identifier of the agency.
  /// 
  /// Returns a [Future] containing the [Agency] entity.
  /// -------------------------------------------------------------------------
  Future<Agency> call(int id) async {
    // Delegates the specific agency fetch to the repository contract
    return await repository.getAgencyById(id);
  }
}