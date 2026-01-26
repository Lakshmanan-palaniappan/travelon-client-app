import 'package:Travelon/core/network/apiclient.dart';
import '../models/agency_model.dart';

/// Abstract definition
abstract class AgencyRemoteDataSource {
  Future<List<AgencyModel>> getAgencies();
}

/// Implementation
class AgencyRemoteDataSourceImpl implements AgencyRemoteDataSource {
  final ApiClient apiClient;

  AgencyRemoteDataSourceImpl(this.apiClient);

  @override
  // features/agency/data/datasources/agency_remote_datasource.dart
  @override
  Future<List<AgencyModel>> getAgencies() async {
    print("⭐⭐⭐⭐⭐⭐⭐⭐⭐");
    // Change from '/agencies' to '/agency'
    final response = await apiClient.get('/agency');

    if (response.statusCode == 200) {
      print("🤣🤣🤣🤣🤣🤣🤣🤣🤣");

      // Check if the API returns { "data": [...] } or just [...]
      final List list = response.data['data'] ?? response.data;
      print(list);
      print("🙄🙄🙄🙄🙄");
      return list.map((json) => AgencyModel.fromJson(json)).toList();
    } else {
      throw Exception("❌ Failed to fetch agencies");
    }
  }
}
