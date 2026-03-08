import 'package:Travelon/core/network/apiclient.dart';
import '../models/agency_model.dart';

/// ---------------------------------------------------------------------------
/// AgencyRemoteDataSource
/// ---------------------------------------------------------------------------
/// Abstract contract for agency-related network operations.
/// 
/// Defines the required methods for retrieving a directory of travel agencies
/// and fetching detailed profiles for individual agency entities.
/// ---------------------------------------------------------------------------
abstract class AgencyRemoteDataSource {
  Future<List<AgencyModel>> getAgencies();
  Future<AgencyModel> getAgencyById(int id);
}

/// ---------------------------------------------------------------------------
/// AgencyRemoteDataSourceImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation of [AgencyRemoteDataSource] using [ApiClient].
/// ---------------------------------------------------------------------------
class AgencyRemoteDataSourceImpl implements AgencyRemoteDataSource {
  final ApiClient apiClient;

  AgencyRemoteDataSourceImpl(this.apiClient);

  /// -------------------------------------------------------------------------
  /// getAgencies
  /// -------------------------------------------------------------------------
  /// Fetches a list of all available travel agencies.
  /// 
  /// Logic:
  /// - Accesses the `/commons/list-agencies` endpoint.
  /// - Uses a fallback to `response.data` if the 'data' key is missing.
  /// - Maps the resulting JSON list into [AgencyModel] instances.
  /// -------------------------------------------------------------------------
  @override
  Future<List<AgencyModel>> getAgencies() async {
    final response = await apiClient.get('/commons/list-agencies');

    if (response.statusCode == 200) {
      // Handles both enveloped and flat JSON list responses
      final List list = response.data['data'] ?? response.data;
      return list.map((json) => AgencyModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch agencies");
    }
  }

  /// -------------------------------------------------------------------------
  /// getAgencyById
  /// -------------------------------------------------------------------------
  /// Retrieves comprehensive details for a specific agency.
  /// 
  /// Parameters:
  /// - [id]: The unique numeric identifier of the agency.
  /// -------------------------------------------------------------------------
  @override
  Future<AgencyModel> getAgencyById(int id) async {
    final response = await apiClient.get('/agency/$id');
    
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      return AgencyModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch agency details");
    }
  }
}