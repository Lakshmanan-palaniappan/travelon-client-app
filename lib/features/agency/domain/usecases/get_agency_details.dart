import '../entities/agency.dart';
import '../repositories/agency_repository.dart';

class GetAgencyDetails {
  final AgencyRepository repository;

  GetAgencyDetails(this.repository);

  Future<Agency> call(int id) async {
    return await repository.getAgencyById(id);
  }
}