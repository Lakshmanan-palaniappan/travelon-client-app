import 'package:Travelon/features/agency/data/datasources/agency_remote_datasource.dart';
import 'package:Travelon/features/agency/domain/entities/agency.dart';
import 'package:Travelon/features/agency/domain/repositories/agency_repository.dart';

/// ---------------------------------------------------------------------------
/// AgencyRepositoryImpl
/// ---------------------------------------------------------------------------
/// The concrete implementation of [AgencyRepository].
/// 
/// This class coordinates data retrieval from remote sources and maps the 
/// results into Domain Entities, ensuring the rest of the application 
/// remains decoupled from the specific API implementation.
/// ---------------------------------------------------------------------------
class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyRemoteDataSource remote;

  AgencyRepositoryImpl(this.remote);

  /// -------------------------------------------------------------------------
  /// getAgencies
  /// -------------------------------------------------------------------------
  /// Retrieves a list of travel agencies from the remote data source.
  /// 
  /// Returns a [Future] list of [Agency] entities.
  /// -------------------------------------------------------------------------
  @override
  Future<List<Agency>> getAgencies() async {
    // Delegates the list retrieval directly to the remote source
    return await remote.getAgencies();
  }

  /// -------------------------------------------------------------------------
  /// getAgencyById
  /// -------------------------------------------------------------------------
  /// Fetches the full profile for a specific agency.
  /// 
  /// Logic:
  /// - Attempts to fetch the [AgencyModel] from the network.
  /// - Wraps the request in a try-catch block to handle communication errors.
  /// - Returns the result as an [Agency] entity.
  /// -------------------------------------------------------------------------
  @override
  Future<Agency> getAgencyById(int id) async {
    try {
      // Fetches raw data which is automatically cast to the Agency entity
      final agencyModel = await remote.getAgencyById(id);
      return agencyModel;
    } catch (e) {
      // Re-throws with a more descriptive context for the presentation layer
      throw Exception("Error fetching agency: $e");
    }
  }
}