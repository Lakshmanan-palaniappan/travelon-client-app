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
}
