import 'package:Travelon/features/agency/domain/entities/agency.dart';
import 'package:Travelon/features/agency/domain/repositories/agency_repository.dart';

class GetAgencies {
  final AgencyRepository repository;

  GetAgencies(this.repository);

  Future<List<Agency>> call() {
    return repository.getAgencies();
  }
}
