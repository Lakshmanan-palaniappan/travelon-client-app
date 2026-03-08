import 'package:Travelon/features/agency/domain/entities/agency.dart';
import 'package:Travelon/features/agency/domain/repositories/agency_repository.dart';

/// ---------------------------------------------------------------------------
/// GetAgencies
/// ---------------------------------------------------------------------------
/// A Use Case responsible for retrieving a list of all travel agencies.
/// 
/// This class acts as a single-purpose command that bridges the 
/// Presentation layer (UI/BLoC) with the Data layer (Repository) 
/// to fetch agency profiles.
/// ---------------------------------------------------------------------------
class GetAgencies {
  final AgencyRepository repository;

  GetAgencies(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the retrieval request.
  /// 
  /// Returns a [Future] list of [Agency] entities.
  /// -------------------------------------------------------------------------
  Future<List<Agency>> call() {
    // Delegates the data fetch to the repository contract
    return repository.getAgencies();
  }
}