import 'package:Travelon/features/agency/domain/entities/agency.dart';

abstract class AgencyRepository {
  Future<List<Agency>> getAgencies();
  Future<Agency> getAgencyById(int id);
}
