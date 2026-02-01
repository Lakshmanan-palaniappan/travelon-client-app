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

  @override
  Future<AgencyModel> getAgencyById(int id) async {
    // Calling the route /agency/:id
    print("Agency data fetching entry");
    final response = await apiClient.get('/agency/$id');
    print("Agency data fetching entry");
    print("response code : ${response.statusCode}");
    if (response.statusCode == 200) {
      // Assuming the agency data is directly in 'data' or the root of response.data
      final data = response.data['data'] ?? response.data;
      return AgencyModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch agency details");
    }
  }

  
}
