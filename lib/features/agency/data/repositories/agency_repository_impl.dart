import 'package:Travelon/features/agency/data/datasources/agency_remote_datasource.dart';
import 'package:Travelon/features/agency/domain/entities/agency.dart';
import 'package:Travelon/features/agency/domain/repositories/agency_repository.dart';

class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyRemoteDataSource remote;

  AgencyRepositoryImpl(this.remote);

  @override
  Future<List<Agency>> getAgencies() async {
    return await remote.getAgencies();
  }
  
@override
Future<Agency> getAgencyById(int id) async {
  try {
    // We call the remote data source and return it as the Agency entity
    final agencyModel = await remote.getAgencyById(id);
    return agencyModel; 
  } catch (e) {
    // You can handle specific failures here (e.g., ServerFailure)
    throw Exception("Error fetching agency: $e");
  }
}
}
