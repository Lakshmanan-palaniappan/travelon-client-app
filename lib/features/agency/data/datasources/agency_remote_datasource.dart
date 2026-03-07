import 'package:Travelon/core/network/apiclient.dart';
import '../models/agency_model.dart';

/// Abstract definition
abstract class AgencyRemoteDataSource {
  Future<List<AgencyModel>> getAgencies();
  Future<AgencyModel> getAgencyById(int id);
}

/// Implementation
class AgencyRemoteDataSourceImpl implements AgencyRemoteDataSource {
  final ApiClient apiClient;

  AgencyRemoteDataSourceImpl(this.apiClient);


  // to get agency lists
  @override
  @override
  Future<List<AgencyModel>> getAgencies() async {
    final response = await apiClient.get('/commons/list-agencies');

    if (response.statusCode == 200) {
      final List list = response.data['data'] ?? response.data;
      return list.map((json) => AgencyModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch agencies");
    }
  }


// to get agency details
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
